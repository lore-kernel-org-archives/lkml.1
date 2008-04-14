Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYDNKhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYDNKhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYDNKhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:37:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYDNKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:37:03 -0400
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080414032232.bc36ba5b.akpm@linux-foundation.org>
References: <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <1208121358.2700.4.camel@shinybook.infradead.org>
	 <20080413154459.4b2f125d.akpm@linux-foundation.org>
	 <20080413234920.63711ca7@core>
	 <20080413161014.cb06964c.akpm@linux-foundation.org>
	 <1208161859.3596.75.camel@skunk.anacadf.mentorg.com>
	 <20080414014445.5b4a7b22.akpm@linux-foundation.org>
	 <20080414090945.GA18494@infradead.org>
	 <20080414022108.92ce9b1d.akpm@linux-foundation.org>
	 <1208167786.31695.34.camel@pmac.infradead.org>
	 <20080414032232.bc36ba5b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 11:36:55 +0100
Message-Id: <1208169415.31695.51.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 03:22 -0700, Andrew Morton wrote:
> Not so.  There is a habit of treating corporate developers as somehow
> inferior to the purer old-timers.  I know - people have told me.  Quite
> often. 

I'm not sure I agree. There is a habit of treating people who post crap
code as somehow inferior to the purer old-timers, certainly. And that's
probably not such a good thing, but at least it helps to keep the
signal:noise ratio down a little, overall.

But except to the extent that there is a correlation between 'corporate
developers' and 'people who post crap code', I wouldn't agree with your
statement above. 

We have a lot of people working for large corporations who don't post
crap code, and to whom Christoph almost never promotes an attitude of
violence. Looking at Jon's 'who wrote 2.6.23' analysis, I see quite a
lot of successful 'corporate' involvement.

> And for various reasons, those people feel limited in their options
> for standing up for themselves.

Anyone trying to defend crap code _should_ be limited in their options,
surely? And sometimes, 'corporate developers' do try to defend crap
code, because they've made traditional corporate mistakes like
developing it all in private and presenting it as a fait accomplis
without proper a priori review, and/or haven't budgeted for the
necessary time to fix it.

-- 
dwmw2

