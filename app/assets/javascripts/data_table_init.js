$(function() {
  if (!$.fn.dataTable.isDataTable('#dataTable')) {
    $('#dataTable').DataTable({
      paging: true,
      searching: true,
      order: [[ 1, 'desc']],
      language: {
        search: 'Buscar',
        paginate: {
          first: 'Primero',
          previous: 'Anterior',
          next: 'Siguiente',
          last: 'Último'
        },
        info: 'Mostrando _START_ de _END_ registros',
        lengthMenu: 'Mostrar _MENU_ registros'
      }
    });
  }
});