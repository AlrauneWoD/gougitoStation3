import { Box, Button, Section, Table } from 'tgui-core/components';
import { toTitleCase } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  materials: Material[];
};

type Material = {
  type: string;
  name: string;
  amount: number;
};

const OREBOX_INFO = `All ores will be placed in here when you are wearing a
mining stachel on your belt or in a pocket while dragging the ore box.`;

export const OreBox = (props) => {
  const { act, data } = useBackend<Data>();
  const { materials } = data;

  return (
    <Window width={335} height={415}>
      <Window.Content scrollable>
        <Section
          title="Ores"
          buttons={<Button content="Empty" onClick={() => act('removeall')} />}
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Ore</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                Amount
              </Table.Cell>
            </Table.Row>
            {materials.map((material) => (
              <Table.Row key={material.type}>
                <Table.Cell>{toTitleCase(material.name)}</Table.Cell>
                <Table.Cell collapsing textAlign="right">
                  <Box color="label" inline>
                    {material.amount}
                  </Box>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section>
          <Box>
            {OREBOX_INFO}
            <br />
            Gibtonite is not accepted.
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
