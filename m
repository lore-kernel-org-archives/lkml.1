Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZEBJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZEBJWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZEBJWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:22:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZEBJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:22:08 -0400
Date: Sat, 2 May 2009 05:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: tridge@samba.org
Cc: Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502092204.GA32066@infradead.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090502015927.GJ8822@parisc-linux.org> <18940.3862.34000.615391@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18940.3862.34000.615391@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 07:15:02PM +1000, tridge@samba.org wrote:
> Unfortunately I am unable to discuss any of the non-technical reasons
> for why "get the VFAT out" might be a good idea in the first
> place. That is damn frustrating, but it is just how things are.

At that point you shouldn't even bother to send a patch.

