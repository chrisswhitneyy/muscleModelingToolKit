function flag = save_all_plots(file_path)
  figure_handles = findobj('Type','figure');
  for i=1:numel(figure_handles)
    saveas(figure_handles(i),[file_path filesep 'figure' num2str(i) '.eps']);
  end
end
