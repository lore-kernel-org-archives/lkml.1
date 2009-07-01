Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZGAMaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZGAMaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZGAMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:30:05 -0400
Received: from mail.samba.org ([66.70.73.150]:53000 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZGAMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:30:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.22108.733265.140158@samba.org>
Date: Wed, 1 Jul 2009 22:28:12 +1000
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <4A4B4D1D.8070308@panasas.com>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<4A4B4D1D.8070308@panasas.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

 > That I understand since short_name is some function of long_name
 > but if I'm just inventing the short_name out of my hat. In what legal
 > system does it matter what is my random function I use?

I like to defer to John Lanza for a more complete answer to this, but
I can tell you that it is not related to the choice of random
function.

I'd also suggest that if anyone wants to go into this in any depth
then private email with John Lanza is the best option.

Cheers, Tridge
