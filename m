Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbZLOT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbZLOT0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbZLOT0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:26:40 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:62327 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbZLOT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:26:40 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.32 build problem on Mint 8 (kubuntu-9.10 i86-x64)
Date: Tue, 15 Dec 2009 14:26:26 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.32; KDE/4.3.3; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200912151426.26285.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just tried to build 2.6.32 for for that Mint 8 install by using mc to copy 
the src's over, then did a "chown -R gene:gene linux-*", cd'd into the tree 
and typed 'make xconfig'  but it errors out, can't find the qt-mt stuff 
installed on the *buntu's.

The  I tried a 'make menuconfig' which also quits quickly because it can't 
find the ncurses stuff either.

At this point, maybe I should have tried as root rather than as a common 
user, me, but I'm told its better not to build this stuff as root.

I took some pix, where should I post them?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Windows 95 never has bugs.  It just develops random features.
