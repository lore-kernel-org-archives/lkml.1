Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZF1FjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZF1FjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZF1Fiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:38:55 -0400
Received: from mail.samba.org ([66.70.73.150]:39361 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZF1Fiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:38:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19015.482.794111.612472@samba.org>
Date: Sun, 28 Jun 2009 15:38:42 +1000
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <m1vdmh2e26.fsf@fess.ebiederm.org>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

 > Given what you have said our interpretation of vfat has a bug,
 > and that small change is a candidate for -stable.  If it could
 > be it's own patch.

good point. 

Hirofumi-san, would you support putting the last_u change into stable?

Cheers, Tridge
