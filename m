Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbXBVTJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbXBVTJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXBVTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:09:10 -0500
Received: from www17.your-server.de ([213.133.104.17]:1485 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXBVTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:09:05 -0500
Message-ID: <45DDEA1D.7060703@m3y3r.de>
Date: Thu, 22 Feb 2007 20:08:13 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20061222)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [ACPI] Several remarks for 9654640d0af8f2de40ff3807d3695109d3463f54
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1.) My kde klaptopdaemon icon is gone. This icon displayed the remaining
battery time. This is maybe a kde problem?

2.) I get these new messages in the kernel log buffer:
[...]
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
[EmbeddedControl] [20070126]
ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands
for [OpcodeName unavailable] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.LPCB.EC__._REG] (Node c190db1c), AE_NOT_FOUND
ACPI Exception (ec-0956): AE_NOT_FOUND, Could not use ECDT [20070126]
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
[...]
ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
[EmbeddedControl] [20070126]
ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands
for [OpcodeName unavailable] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node c190dbbc), AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.BAT0.UBSS] (Node c190da2c), AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.BAT0._STA] (Node c190da7c), AE_NOT_FOUND
ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
[EmbeddedControl] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.LPCB.EC__._REG] (Node c190db1c), AE_NOT_FOUND
ACPI Exception (evregion-0513): AE_NOT_FOUND, from region _REG,
[EmbeddedControl] [20070126]
ACPI: PCI Root Bridge [PCI0] (0000:00)

But i guess this is ok and seems to be an acpi problem on my computer,
aren't they?

mfg
thomas

