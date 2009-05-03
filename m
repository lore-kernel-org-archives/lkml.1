Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZECXPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZECXPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZECXPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:15:35 -0400
Received: from mail.samba.org ([66.70.73.150]:53869 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZECXPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:15:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18942.9606.411013.714178@samba.org>
Date: Mon, 4 May 2009 09:15:18 +1000
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <20090503225616.GD8633@ZenIV.linux.org.uk>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	<20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090502015927.GJ8822@parisc-linux.org>
	<18940.3862.34000.615391@samba.org>
	<20090502092204.GA32066@infradead.org>
	<18940.4762.726933.677059@samba.org>
	<20090503215727.GF1368@ucw.cz>
	<18942.6593.544212.571063@samba.org>
	<20090503225616.GD8633@ZenIV.linux.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

 > Practical consequences of establishing that kind of precedent (applying
 > a patch on the grounds of nothing but vague references to possibly
 > legal problems, with author explicitly refusing to explain exact reasons)
 > can also be non-trivial...  And I'm not sure that it won't have legal
 > ones as well, while we are at it.

You are absolutely right. For that reason, I expect that anyone who
does finally make the decision to include this patch, or something
like it, will have had a long discussion with a lawyer first, and will
fully understand the reasons for it.

Meanwhile though, there is something we can do here in public, which
is to discuss the technical merits of the proposed patch. It might be
that you or someone else can come up with a better technical approach.

I also realise that discussing the technical merits of a patch without
first establishing the exact non-technical reasons for the patch is
difficult, but as Hirofumi-san has shown, it is possible.

Cheers, Tridge
