Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZGBWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZGBWl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZGBWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:41:24 -0400
Received: from mail.samba.org ([66.70.73.150]:41702 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZGBWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:41:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.14217.587592.808935@samba.org>
Date: Fri, 3 Jul 2009 08:41:13 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702223349.GA30840@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090702214646.GD1485@ucw.cz>
	<19021.12158.915384.574218@samba.org>
	<20090702223349.GA30840@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > So you know it causes XP to bluescreen, but can not reproduce that. So
 > what? Someone, somewhere _will_ reproduce it.

yes, like someone, somewhere will get data corruption in a TCP
connection because the checksum is quite weak and networking hardware
ain't perfect. 

Once the probabilties become small enough then it is normal to accept
imperfection in operating systems. If I could make it perfect I would,
but I haven't thought of a way to do that while being absolutely sure
of maintaining the full strength of the legal defence.

If you find a way to actually produce this problem in a way that is
realistic for Linux users then let me know. Otherwise I think it is
the best option we have, imperfect though it is. 

Cheers, Tridge
