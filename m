Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXCLLLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXCLLLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965551AbXCLLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:11:54 -0400
Received: from lnx130.hrz.tu-darmstadt.de ([130.83.174.24]:43027 "EHLO
	lnx130.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965513AbXCLLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:11:53 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 07:11:52 EDT
From: ST <st@iss.tu-darmstadt.de>
To: linux-kernel@vger.kernel.org
Subject: Gigabyte GA-M57SLI-S4 (the linuxbios compatible version) problems
Date: Mon, 12 Mar 2007 12:10:15 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121210.15812.st@iss.tu-darmstadt.de>
X-TUD-HRZ-MailScanner: Found to be clean
X-TUD-HRZ-MailScanner-SpamCheck: 
X-MailScanner-From: st@iss.tu-darmstadt.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to boot 2.6.20.2 on a Gigabyte GA-M57SLI-S4 with f7 stock bios.
I get the message:
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ... failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!

I can boot with noapic option but then i only have one processor (AMD X2 3800+ 
stepping 02).

apic=debug doesn't give any more output than this. 

A bios update didn't help to the f7 version didn't help. This error is also 
present with the debian stock kernel.

I thought that this MB should be pretty good supported, given the fact that 
there is an linuxbios in the works for this MB or am i bitten by a HW 
failure?

Thanks
ST

PS: please CC not on list.
