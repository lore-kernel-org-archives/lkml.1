Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZABJ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZABJ6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZABJ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:58:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbZABJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:58:47 -0500
Date: Fri, 2 Jan 2009 04:58:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
Message-ID: <20090102095842.GA24652@infradead.org>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com> <Pine.LNX.4.64.0901011048090.14380@anakin> <20090101170329.GA17892@infradead.org> <Pine.LNX.4.64.0901021056360.14380@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901021056360.14380@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:57:43AM +0100, Geert Uytterhoeven wrote:
> > Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following
> 
> x86-32 or -64?
> 
> It may also depend on the compiler version. I have gcc version 4.1.2 20061115
> (prerelease) (Debian 4.1.1-21).

32 bit, gcc version 4.3.2 (Debian 4.3.2-1) 

