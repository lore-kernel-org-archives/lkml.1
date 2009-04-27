Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZD0NN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZD0NN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZD0NNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:13:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55831 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZD0NNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:13:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 15:13:33 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-21-git-send-email-monstr@monstr.eu> <200904271453.47038.arnd@arndb.de> <49F5AD3D.1050101@monstr.eu>
In-Reply-To: <49F5AD3D.1050101@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271513.34269.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/i8cT8dfqBuLN1hNIVtJVg3i3jgj1kNyLhwqn
 4mma52CuSp8YrexoLNZkrcB/qzXtgRmrxC476B/pzPVtQzmvbQ
 UhAPl/pxxO8nwKk3V4TCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Michal Simek wrote:
> > I still think that there are major changes that should be done to the
> > Microblaze ABI. I actually did most of the work for this, but then you
> > beat be by getting it upstream first ;-)
> 
> For me is/was good that I could focus on MMU part and no to spend all my time to moving noMMU
> patches and wait for future changes. Community is sending patches for Microblaze and for me is
> easier to manage small changes not drag bunch of 50 patches to next version.

Oh, absolutely, and I think it's great that you managed to get it all in, as
it also makes my job easier. It just means that any ABI change now has to
be thought through much more.

> > I suppose it's much too late for 2.6.30 now, but maybe we can do one major
> > ABI change to microblaze by making the ABI totally generic in the next
> > merge window. I'll follow up with an RFC for this.
> 
> If you propose me changes, I'll try to test it. If the results are OK, I'll add it to next merge
> open window for Microblaze. As I wrote before I am open to your visions and if microblaze is in
> mainline I can test it easier than before.

ok.

	Arnd <><
