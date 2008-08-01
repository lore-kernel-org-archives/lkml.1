Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYHAQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYHAQw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYHAQwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:52:50 -0400
Received: from iabervon.org ([66.92.72.58]:34168 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYHAQwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:52:49 -0400
Date: Fri, 1 Aug 2008 12:52:48 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Jonathan Corbet <corbet@lwn.net>,
       Alex Chiang <achiang@hp.com>, LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
In-Reply-To: <4892E703.8060507@s5r6.in-berlin.de>
Message-ID: <alpine.LNX.1.00.0808011233061.19665@iabervon.org>
References: <20080729143015.0f79cf37@bike.lwn.net> <20080731062305.GA18070@ldl.fc.hp.com> <20080731101738.1bf4281c@bike.lwn.net> <alpine.LNX.1.00.0807311249320.19665@iabervon.org> <Pine.LNX.4.64.0807311055400.6503@shark.he.net>
 <4892E703.8060507@s5r6.in-berlin.de>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Stefan Richter wrote:

> Randy.Dunlap wrote:
>
> > but.. but Andrew often has to take part(s) of #0/N and add them to the
> > changelog(s) to make the changelog(s) meaningful.  I.e., someone skimped
> > on what should have been in the changelog(s).
> 
> That would not be a problem with the cover posting, it would be a
> problem with the changelogs.  The same applies if the respective
> information is put below the '---' delimiter line in the individual
> patch postings. 

Or, for that matter, left out entirely. Or in the first actual patch of 
the series, since people will often be looking through the log filtered in 
some way, or bisect or blame will take them to the middle of the series.

> So just remember that changelogs need to be sufficiently comprehensive 
> even when read standalone, out of the context of the series.

I think this would be a good statement to include in the section about 
changelogs.

	-Daniel
*This .sig left intentionally blank*
