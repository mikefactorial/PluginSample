using Microsoft.Xrm.Sdk;
using System;
using System.Linq;

namespace Plugins
{
    /// <summary>
    /// Plugin development guide: https://docs.microsoft.com/powerapps/developer/common-data-service/plug-ins
    /// Best practices and guidance: https://docs.microsoft.com/powerapps/developer/common-data-service/best-practices/business-logic/
    /// </summary>
    public class AccountPlugin : PluginBase
    {
        public AccountPlugin(string unsecureConfiguration, string secureConfiguration)
            : base(typeof(AccountPlugin))
        {
            // TODO: Implement your custom configuration handling
            // https://docs.microsoft.com/powerapps/developer/common-data-service/register-plug-in#set-configuration-data
        }

        // Entry point for custom business logic execution
        protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
        {
            if (localPluginContext == null)
            {
                throw new ArgumentNullException(nameof(localPluginContext));
            }

            var context = localPluginContext.PluginExecutionContext;

            // Check for the entity on which the plugin would be registered
            if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity && localPluginContext.PluginExecutionContext.Stage == 40 && localPluginContext.PluginExecutionContext.MessageName == "Create")
            {
                var entity = (Entity)context.InputParameters["Target"];

                // Check for entity name on which this plugin would be registered
                if (entity.LogicalName == "account")
                {
                    localPluginContext.Trace("Account Create Plugin");
                    var task = new Entity("task");
                    var account = localPluginContext.PluginExecutionContext.PostEntityImages.Values.FirstOrDefault();
                    task["subject"] = $"Please follow up with new account ({account?.GetAttributeValue<string>("name")}).";
                    task["regardingobjectid"] = new EntityReference() { Id =  account.Id, LogicalName = "account" };
                    localPluginContext.InitiatingUserService.Create(task);
                }
            }
        }
    }
}
