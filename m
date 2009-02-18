Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZBRNYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZBRNYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZBRNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:24:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:60540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZBRNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:24:19 -0500
Date: Wed, 18 Feb 2009 14:28:35 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28.[5,6] _GTF unexpected object type 0x1
Message-ID: <20090218132835.GA7253@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: private site
User-Agent: Mutt/1.5.19+cvs20090214 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1/OuP4bvGpQ+16yLBIM6kos3aMj4ZfSxKFM0RU
 vMr69XPQnAUcmf++V+xd8/Q0GNZNLhAmRRLr1K4+q44pHjgupG
 AV9pGgtvjNBKbLXL0Z1CXw03XXKo5Xj6vu1Fb1jS68=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

did switch to 2.6.28.6 from 2.6.25 today on my Lenovo 3000 N200 Laptop,
and noticed this error while booting (which wasn't there with 2.6.25):

[....]
<6>ata3: SATA max UDMA/133 abar m2048@0xfc504000 port 0xfc504200 irq 507
<6>ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<4>ACPI Warning (nspredef-0852): \_SB_.PCI0.SATA.PRT0._GTF: Return type mismatch - found Integer, expected Buffer [20080926]
<4>ata1.00: _GTF unexpected object type 0x1
<6>ata1.00: ATA-7: WDC WD1600BEVS-08RST2, 08.01G08, max UDMA/133
<6>ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
<4>ata1.00: _GTF unexpected object type 0x1
<6>ata1.00: configured for UDMA/133
[....]

So far, all seems to work properly, but I haven't used the machine any
longer yet. 

Is this a serial issue which I have to worry about, and what can I do to avoid it?




