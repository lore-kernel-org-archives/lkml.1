Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYKZAFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYKZAFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYKZAF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:05:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbYKZAF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:05:27 -0500
Date: Tue, 25 Nov 2008 16:05:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Carrijo <fcarrijo@yahoo.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix similar typos to successfull, v2
Message-Id: <20081125160524.102a2b3a.akpm@linux-foundation.org>
In-Reply-To: <1227656953.18268.13.camel@pc-fernando>
References: <492AE7ED.8040304@suse.de>
	<20081125145308.8633bf4a.akpm@linux-foundation.org>
	<1227656953.18268.13.camel@pc-fernando>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 21:49:13 -0200
Fernando Carrijo <fcarrijo@yahoo.com.br> wrote:

> On Tue, 2008-11-25 at 14:53 -0800, Andrew Morton wrote:
> > On Tue, 25 Nov 2008 01:44:13 +0800
> > Coly Li <coyli@suse.de> wrote:
> > 
> > > When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
> > > in kernel tree, 22 typos found totally --  great minds always think alike  :)
> > 
> > Mutter.  I have a super-strict (lol) policy of "I don't take patches
> > which fix typos/spellos in comments", because we have so many such
> > errors, and I'd get buried in silly patches.  But I do take patches
> > which fix documentation and user-visible printks, etc.
> 
> Since you started the thread, I feel less guilty to talk about the
> existence of tons of another kind of typo spread around the kernel
> sources: null statements created by duplicated semi-colons at the end of
> statements. Something like foo();;

We should just fix those.
