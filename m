Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZF3Azu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZF3Azu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZF3Azl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:55:41 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40365 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZF3Azk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:55:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
	<19016.6463.997760.757811@samba.org>
	<20090629221826.GA12781@kroah.com>
	<19017.17250.371594.268824@samba.org>
	<87tz1ymx3m.fsf@devron.myhome.or.jp>
	<19017.21349.354386.847874@samba.org>
Date: Tue, 30 Jun 2009 09:55:39 +0900
In-Reply-To: <19017.21349.354386.847874@samba.org> (tridge@samba.org's message
	of "Tue, 30 Jun 2009 09:51:01 +1000")
Message-ID: <87fxdimtf8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

>  > The default may be arguable though, like I said at first.
>
> I suggest we leave the default as "no dual names" for now to let it
> get some more testing, then if any problems come up then we can look
> at the choice of default again. If no problems come up we can keep the
> default as it is in the patch now.

Ok, I've applied the patch + Cc: to fatfs-2.6.git.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
