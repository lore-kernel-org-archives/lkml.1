Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZF2XvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZF2XvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZF2XvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:51:15 -0400
Received: from mail.samba.org ([66.70.73.150]:60419 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZF2XvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:51:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19017.21349.354386.847874@samba.org>
Date: Tue, 30 Jun 2009 09:51:01 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <87tz1ymx3m.fsf@devron.myhome.or.jp>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org>
	<19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
	<19016.6463.997760.757811@samba.org>
	<20090629221826.GA12781@kroah.com>
	<19017.17250.371594.268824@samba.org>
	<87tz1ymx3m.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirofumi-san writes:
 > Yes. And I will not drop this patch even if it's not perfect on test. I
 > can understand it would not be the option for some users.

ok, good

 > The default may be arguable though, like I said at first.

I suggest we leave the default as "no dual names" for now to let it
get some more testing, then if any problems come up then we can look
at the choice of default again. If no problems come up we can keep the
default as it is in the patch now.

Cheers, Tridge
