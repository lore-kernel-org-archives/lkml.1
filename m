Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZFBPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZFBPKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZFBPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:09:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZFBPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:09:52 -0400
Date: Tue, 2 Jun 2009 17:09:52 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602150952.GB17448@wotan.suse.de>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602124757.GG1065@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 02:47:57PM +0200, Andi Kleen wrote:
> On Tue, Jun 02, 2009 at 02:00:42PM +0200, Nick Piggin wrote:

[snip: reusing truncate.c code]

> > With all that writing you could have just done it. It's really
> 
> I would have done it if it made sense to me, but so far it hasn't.
> 
> The problem with your suggestion is that you do the big picture,
> but seem to skip over a lot of details. But details matter.

BTW. just to answer this point. The reason maybe for this
is because the default response to my concerns seems to
have been "you're wrong". Not "i don't understand, can you
detail", and not "i don't agree because ...".

I may well be wrong (in this case I'm quite sure I'm not),
but if you say I'm wrong, then I assume that you understand
what I'm talking about and have a fair idea of the details.

Anyway don't worry. I get that a lot. I do really want to
help get this merged.

