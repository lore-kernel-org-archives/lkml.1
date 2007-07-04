Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbXGDTun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbXGDTun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXGDTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:50:35 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:46779 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbXGDTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:50:34 -0400
Date: Wed, 04 Jul 2007 15:50:22 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: speed trends in pata world.
To: linux-kernel@vger.kernel.org
Message-id: <200707041550.22533.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

The drive speeds seem to be going the wrong way.  Its an nforce2 equipt mobo, 
and I have 3 drives currently in this box.  Running 2.6.22-rc6-cfs-v18 + the 
ftdi_sio.c patch.

hda, the primary on cable 0, is running at around 28MB/Sec.  Its a 200GB WD 
about 2 years old.

hdb, is running at around 79MB/Sec, its a 4 year old 120GB WD.
hdd is running at about 75MB/Sec, is a nearly new 300GB WD.

Can I read anything into the fact that the 2 fast drives are on the slave end 
of the cables, whereas the slow one is master in the middle of the cable?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Dumb terminal
