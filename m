Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYGNLZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYGNLZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYGNLZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:25:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYGNLZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:25:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Subject: Re: Microblaze architecture - ACK
Date: Mon, 14 Jul 2008 13:24:56 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Jon Loeliger <jdl@jdl.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Sam Ravnborg <sam@ravnborg.org>
References: <487B19E0.3030301@seznam.cz>
In-Reply-To: <487B19E0.3030301@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141324.56731.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/EXEcM3pcJtFweTac3doC5fsQervXipxTZ99B
 BLQMsvG/Ed3R05ppNyMquMFqVZZzXpCRoCG9fZvYf6/CTP/FrY
 /wG8i4YwQ15nYnjEe6EDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008, Michal Simek wrote:
> Arnd: I hope you know much about microblaze. Could you help me with the last
> stage of merging?
> 
> Could you recommend me people who can give me valuable ACK? (I'll send patches
> to them and then full pack to LKML too).
> 

I think most of it is fine by now, but I haven't received any reply from you
on my lenghy mail "Re: Microblaze init port v4" sent at 26.06.2008 19:51 MEST
or the other one "Re: [PATCH 59/60] microblaze_v4: syscall_table.S and
unistd.h" at 26.06.2008 18:31 CEST.

I think I raised some important issues regarding your syscall interface in
these, and the same problems persisted in version 5. If you address my
comments there (either by changing the code or convincing me that no change
is needed), you have my full Ack on the port.

	Arnd <><
