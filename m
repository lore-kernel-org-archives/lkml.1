Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZEBJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZEBJab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZEBJaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:30:20 -0400
Received: from mail.samba.org ([66.70.73.150]:53168 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZEBJaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:30:18 -0400
X-Greylist: delayed 838 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2009 05:30:18 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.4762.726933.677059@samba.org>
Date: Sat, 2 May 2009 19:30:02 +1000
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <20090502092204.GA32066@infradead.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	<20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090502015927.GJ8822@parisc-linux.org>
	<18940.3862.34000.615391@samba.org>
	<20090502092204.GA32066@infradead.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

 > At that point you shouldn't even bother to send a patch.

The non-technical reasons for this patch are available to anyone who
cares to read any of the many news sites that discuss recent
events. The fact that I can't discuss those reasons shouldn't preclude
me from proposing a technical solution which tries to minimise the
impact on Linux users.

I'm hoping that you and others will look at the proposed technical
solution to the non-technical problem, and perhaps suggest better
approaches. There are a wide variety of approaches to avoiding this
problem, and we need to work out which, if any, should be part of the
kernel.org releases.

Cheers, Tridge
