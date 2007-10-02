Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXJBKua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXJBKua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJBKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:50:16 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:38426 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbXJBKuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:50:15 -0400
Date: Tue, 02 Oct 2007 06:50:02 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: shutdown -h now, 2.6.23-rc8 & 9
To: linux-kernel@vger.kernel.org
Message-id: <200710020650.02613.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings everybody;

After seeing a message indicating that rc8 no longer did a powerdown, I 
thought I'd check that since I needed to, my tv card wasn't even showing up 
in the lspci report. It was partially backed out of the pci slot, this case 
seems to encourage that.

Indeed it went to the system halted message and just sat there.  I hadn't yet 
booted to rc9 as amanda was running, so I did just a few minutes ago.

After the reboot to rc9, I ran a make xconfig again to check that the option 
was enabled, but it seems to have disappeared from the menus in xconfig.

Why was this removed?  Or if moved, where to?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<mdorman> I'm a gnus person myself.  It's an editor!  It's a floorwax!
          It's a dessert topping!
