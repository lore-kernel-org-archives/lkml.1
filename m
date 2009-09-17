Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZIQLlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZIQLlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZIQLlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:41:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:51813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZIQLlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:41:15 -0400
Date: Thu, 17 Sep 2009 13:41:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917114116.GL18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917111828.GB7205@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 12:18:28PM +0100, Mel Gorman wrote:
> On Thu, Sep 17, 2009 at 02:13:39PM +0300, Pekka Enberg wrote:
> > On Thu, 2009-09-17 at 11:08 +0100, Mel Gorman wrote:
> > > > > The danger is if SLQB is being silently disabled, it'll never be noticed
> > > > > or debugged :/
> > > > 
> > > > Maybe, but that's not an excuse to push something that's known to break. 
> > 
> > On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > > Wow, this is from back in May! Lame.
> > 
> > Heh, my (lame) excuse is lack of relevant hardware.... ;-)
> > 
> 
> I'm not blaming you. It's just ... unfortunate :/

Ahh... it's pretty lame of me. Sachin has been a willing tester :(
I have spent quite a few hours looking at it but I never found
many good leads. Much appreciated if you can make more progress on
it.

