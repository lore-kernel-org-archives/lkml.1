Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbZIQLzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbZIQLzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZIQLzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:55:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49217 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZIQLzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:55:49 -0400
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Sachin Sant <sachinp@in.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090917115252.GO18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
	 <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie>
	 <4AB21C3D.2080202@in.ibm.com> <20090917113837.GK18404@wotan.suse.de>
	 <84144f020909170443y5f8c3c8fo7d2a4163e636f368@mail.gmail.com>
	 <20090917115252.GO18404@wotan.suse.de>
Date: Thu, 17 Sep 2009 14:55:51 +0300
Message-Id: <1253188551.4975.50.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 13:52 +0200, Nick Piggin wrote:
> > Me sending anything but bug fixes to Linus after the merge window is
> > closed...? That's one scary thought!
> 
> Well, I don't know if it is much different than merging with known
> bugs and expecting to resolve them. Maybe it circumvents the
> _letter_ of the merge window law, but in spirit it is probably
> nicer to merge after fixing the bug :)
> 
> But I'll let you decide how to proceed.

I'll just wait for a fix to appear. Saves me from sleepless nights while
worrying for Linus' revenge.

			Pekka

