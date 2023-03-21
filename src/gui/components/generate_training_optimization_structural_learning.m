function generate_training_optimization_structural_learning(app)

 app.training_optimization_structural_learning = axes('Parent',...
     app.OptPanelSL, 'Units', 'pixels', 'OuterPosition',...
     [471 359 412 340], 'InnerPosition', [510.4 394.4 364.1 285.3],...
     'Box', 'on');

set_common_plot_settings(app.training_optimization_structural_learning);
 
set_no_tick(app.training_optimization_structural_learning);
 
app.training_optimization_structural_learning.Title.String = 'Train Likelihood';
app.training_optimization_structural_learning.XLabel.String = 'Lambda';
app.training_optimization_structural_learning.YLabel.String = 'Train Likelihood';
app.training_optimization_structural_learning.FontName='Arial';
app.training_optimization_structural_learning.FontSize=8;

end