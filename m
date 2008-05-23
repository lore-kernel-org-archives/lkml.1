Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYEWO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYEWO2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYEWO2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:28:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38713 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYEWO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:28:37 -0400
Date: Fri, 23 May 2008 07:11:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Natalie Protasevich <protasnb@gmail.com>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080523071157.3cfdc03a@infradead.org>
In-Reply-To: <20080523090940.GG2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	<20080522144114.GC27301@cs181133002.pp.htv.fi>
	<20080522075135.4933161c@infradead.org>
	<20080522155425.GA2727@cs181133002.pp.htv.fi>
	<32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
	<20080522165008.GB2727@cs181133002.pp.htv.fi>
	<20080522151834.03f2790f@infradead.org>
	<20080523090940.GG2727@cs181133002.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 12:09:40 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> 
> And in case anyone says "not forwarded distribution bugs aren't our 
> problem":
> That's a nice example, since in this case a distribuion suddenly 
> starting to agressively forwarding their bugs might contribute to
> making the kernel better, but might also totally ruin the numbers in
> any statistics.

Fedora gets less than 1000 bugs per release (so 6 month window).
That's... peanuts.
(Also remember that distribution bugs have a real percentage of "please
help me" support request bugs, so the actual nr of bugs is quite
lower. The number is also before duplicates are marked).

We are tracking over 3000 bugs per WEEK via other channels.

So yes I will say that distribution bugs, while nice if we get
visibility in the good ones, aren't the end-all thing.
