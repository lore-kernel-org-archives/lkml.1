Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZGCADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZGCADx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZGCADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:03:43 -0400
Received: from ozlabs.org ([203.10.76.45]:50506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZGCADm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:03:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Date: Fri, 3 Jul 2009 09:33:38 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz>
In-Reply-To: <20090702224446.GD30840@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030933.39589.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 08:14:46 am Pavel Machek wrote:
> On Fri 2009-07-03 08:41:13, tridge@samba.org wrote:
> > If you find a way to actually produce this problem in a way that is
> > realistic for Linux users then let me know. Otherwise I think it is
> > the best option we have, imperfect though it is.
>
> So, you know that particular option will cause someone's XP to
> bluescreen, and  you still want it to default to "Y"?

No, his point is the opposite: the rate of incidence of bluescreens on XP will 
not measurably increase due to this patch.

Cheers,
Rusty.
