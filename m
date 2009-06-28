Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbZF1GZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbZF1GZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 02:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZF1GZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 02:25:06 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:41257 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZF1GZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 02:25:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: ebiederm@xmission.com (Eric W. Biederman), john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
Date: Sun, 28 Jun 2009 15:25:02 +0900
In-Reply-To: <19015.482.794111.612472@samba.org> (tridge@samba.org's message
	of "Sun, 28 Jun 2009 15:38:42 +1000")
Message-ID: <87ab3sx4ch.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

>  > Given what you have said our interpretation of vfat has a bug,
>  > and that small change is a candidate for -stable.  If it could
>  > be it's own patch.
>
> good point. 
>
> Hirofumi-san, would you support putting the last_u change into stable?

If you want, I have no problem to do. However, I'm not thinking that
part is a bug.  And -stable rule is also "a real bug that bothers
people", but there is even a no bug reporter which tell actual problem.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
