Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbXKCTQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbXKCTQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXKCTP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:15:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51797 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXKCTPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:15:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472CC8D9.8070609@s5r6.in-berlin.de>
Date: Sat, 03 Nov 2007 20:15:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de>	<m3fy09ffp9.fsf@maximus.localdomain>	<4719A0C4.3050301@s5r6.in-berlin.de>	<m3bqausztv.fsf@maximus.localdomain>	<4719FF0F.3080504@s5r6.in-berlin.de>	<m3ejfp4bg9.fsf@maximus.localdomain>	<4724C9DA.7030900@s5r6.in-berlin.de>	<m33avvdlbq.fsf@maximus.localdomain>	<47251744.6090206@s5r6.in-berlin.de> <m3abq2ccb6.fsf@maximus.localdomain>
In-Reply-To: <m3abq2ccb6.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> The difference is of course at 0x0E, not 0x1E. Maybe the byte at 0x0A
> is 0x92 for 4 IR contents and 0xA2 for 8 contents. That would also
> make sense wrt the broken 6306 as it has 0x00 there.

Somebody pointed me to this thread in a support forum of Asustek:
http://vip.asus.com/forum/view.aspx?id=20070710054607250&board_id=1&model=M2A-VM+HDMI
For special occasions, Asustek hand out a testing and reprogramming
utility from VIA to their customers (viafire.exe, together with EEPROM
image files and instructions; see the link to the RAR archive at this
page).  The documentation of the tool also contains a partial
description of the EEPROM contents.
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
