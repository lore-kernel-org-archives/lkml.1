Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYG2EPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYG2EPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYG2EPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:15:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58765 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYG2EPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:15:42 -0400
Date: Tue, 29 Jul 2008 00:15:39 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Jon Smirl <jonsmirl@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080729041539.GD9378@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jon Smirl <jonsmirl@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
	lkml <linux-kernel@vger.kernel.org>
References: <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com> <488E1147.5040803@simon.arlott.org.uk> <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080729011526.GF28946@ZenIV.linux.org.uk> <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com> <20080729013650.GG28946@ZenIV.linux.org.uk> <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com> <20080729025016.GT9378@mit.edu> <9e4733910807282023h5479c755wde55e2324909b678@mail.gmail.com> <20080729041337.GC9378@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729041337.GC9378@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:13:37AM -0400, Theodore Tso wrote:
> Personally, I have no objection to the mailmap file as it's on the
> whole an improvement; if it's been automatically generated and it
> falsely maps multiple people to a single person, that would be highly
> unfortunate, but maybe it fixes more problems than it creates.

Typo correction.  The first part of that sentence should read:

"Personally, I have no objection to the mailmap file IF on the
whole it's an improvement...."

> I think the part most people are seriously objecting to is that the
> supposition that Linus and some of his top lieutenants should be
> enforcing some arbitrary rule that rejects commits if they come from
> addresses outside of your .mailmap file (unless they first send a
> patch to add their e-mail address to the .mailmap file), in some kind
> of misguided attempt to enforce validation, which apparently the main
> justification for which is so that you and others can runs some
> statistical analysis, of which there seems to be some dispute whether
> or not encouraging people to compete to get into the top 20
> signed-off-by by splitting up commits into 100 different micro-patches
> should be considered a desirable side effect of said statistical
> analysis.
> 
> As I said earlier, the moment you started advocating enforcing
> validation, you may have started to confuse which is the tail and
> which is the dog.  People should be supplying patches to improve the
> kernel; not to provide accurate fodder for statistical analysis.
> 
> 						- Ted
