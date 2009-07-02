Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZGBX7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZGBX7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZGBX7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:59:45 -0400
Received: from mail.samba.org ([66.70.73.150]:46462 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZGBX7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:59:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.18919.560478.630755@samba.org>
Date: Fri, 3 Jul 2009 09:59:35 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702224446.GD30840@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090702214646.GD1485@ucw.cz>
	<19021.12158.915384.574218@samba.org>
	<20090702223349.GA30840@elf.ucw.cz>
	<19021.14217.587592.808935@samba.org>
	<20090702224446.GD30840@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > That's why we have ethernet checksums. 

which of course just changes the number of bits. The argument remains
the same. 

 > It already _was_ perfect before you started patching it.

wow, I really didn't expect the objection to my patch to be that VFAT
is perfect!

Cheers, Tridge
