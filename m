Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZECV54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZECV54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZECV5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:57:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34609 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZECV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:57:35 -0400
Date: Sun, 3 May 2009 23:57:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090503215727.GF1368@ucw.cz>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090502015927.GJ8822@parisc-linux.org> <18940.3862.34000.615391@samba.org> <20090502092204.GA32066@infradead.org> <18940.4762.726933.677059@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18940.4762.726933.677059@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-05-02 19:30:02, tridge@samba.org wrote:
> Hi Christoph,
> 
>  > At that point you shouldn't even bother to send a patch.
> 
> The non-technical reasons for this patch are available to anyone who
> cares to read any of the many news sites that discuss recent
> events. The fact that I can't discuss those reasons shouldn't preclude

Is reading /. now required part of patch reviewer's day?

You are

1) submitting the patch

2) saying that reasons for it are non-technical and obvious

3) saying that you can't tell us the reasons.

Well if they are obvious, please get us someone who _can_ discuss them
with us. Preferably a lawyer that can explain why the patch is
neccessary.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
