Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZF1DAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZF1DAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 23:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZF1C7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 22:59:51 -0400
Received: from mail.samba.org ([66.70.73.150]:35721 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZF1C7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 22:59:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19014.56477.311713.975403@samba.org>
Date: Sun, 28 Jun 2009 12:59:41 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Can't we make this a runtime option?

John may be able to give you a more detailed answer, but the short
answer is that it is much safer legally to not have the code in the
binary kernel image at all.

Cheers, Tridge
