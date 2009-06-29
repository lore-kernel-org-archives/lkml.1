Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZF2BbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZF2BbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZF2BbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:31:01 -0400
Received: from mail.samba.org ([66.70.73.150]:57206 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZF2BbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:31:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.6463.997760.757811@samba.org>
Date: Mon, 29 Jun 2009 11:30:39 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: ebiederm@xmission.com (Eric W. Biederman), john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <87ab3sx4ch.fsf@devron.myhome.or.jp>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org>
	<19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hirofumi-san,

 > If you want, I have no problem to do. However, I'm not thinking that
 > part is a bug.  And -stable rule is also "a real bug that bothers
 > people", but there is even a no bug reporter which tell actual problem.

ok, then what about pushing the whole patch into -stable?

The 'bug' in this case is like a security hole, with Microsoft
demonstrating an active exploit. This falls outside the normal range
of bug fixes for -stable, but I think you'd have to agree that the
whole situation is unusual.

Cheers, Tridge
