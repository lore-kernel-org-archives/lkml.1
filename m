Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYDOPYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYDOPYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYDOPXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:23:55 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51336 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYDOPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:23:55 -0400
Date: Tue, 15 Apr 2008 16:23:13 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dwmw2@infradead.org, hch@infradead.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415152313.GB8513@shareable.org>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org,
	hch@infradead.org, akpm@linux-foundation.org, me@bobcopeland.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu> <20080414223556.GA21340@shareable.org> <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> > > How old?  The out of tree fuse module (hoping to get rid of it soon)
> > > works down to 2.6.9.  Beyond that it does probably require a fair
> > > amount of porting work.
> > 
> > I imagine that backporting FUSE to 2.4 no-mmu will be more work than
> > backporting a filesystem, but I could be mistaken.  Moving my project
> > to a 2.6 kernel (*any* 2.6 kernel) would be much more work than
> > either.
> 
> Fuse-2.5 still supported linux-2.4.  Although I have no idea if it
> works with no-mmu, maybe it's worth a try.
> 
> Backporting ntfs-3g to an older version of fuse shouldn't be a big
> problem, as the fuse interface didn't change very much since then.

Thanks for your advice.  I will look into all these possibilities.
Fuse working would be quite useful in many other ways too.

-- Jamie
