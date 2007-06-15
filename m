Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbXFOSFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbXFOSFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXFOSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:04:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46075
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXFOSEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:04:48 -0400
Date: Fri, 15 Jun 2007 11:02:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Greaves <david@dgreaves.com>, Daniel Hazelton <dhazelton@enter.net>,
       Michael Gerdau <mgd@technosis.de>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706151101240.12349@asgard.lang.hm>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706142049.41819.dhazelton@enter.net> <200706150825.15491.mgd@technosis.de>
 <200706150520.15086.dhazelton@enter.net> <46726793.1020206@dgreaves.com>
 <alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Linus Torvalds wrote:

>
> Now, by your own logic, let's look at what that means for the license.
> Should we write into our copyright license that you cannot try to find
> security holes? Would that be a good addition to the GPLv2?
>
> Now, I stated that in a way where the answer is obvious: that would be a
> *horrible* addition to the GPLv2. I think everybody can agree on that. It
> would be really stupid to say "you cannot look for security holes" just
> because *some* people who do it are bad.
>
> Now, think about that for a moment, and then go back to your question
> about whether Tivo is bad for the community, and whether being bad for the
> community should mean that the license should be written to say "go away
> and don't use future improvements to our software".
>
> See where I'm trying to take you?
>
> I think that even people who *do* think that what Tivo did was "bad",
> should think very deeply about the issue whether you should try to lock
> out "bad uses" in your license. Yes, the answer may be "yes, you should".
> But I'm arguing that the answer _may_ also be: "No, you shouldn't, becasue
> it turns out that you might lock out _good_ people too".
>
> So in my cracker/spammer example, by trying to lock out the bad people,
> the obvious (and _stupid_ - don't get me wrong, I'm not at *all*
> suggesting anything like that should ever be done) license addition of
> "don't expose security problems" actually just causes more problems than
> it solves (if it solves anything at all - really bad people don't actually
> tend to even care about the license!).
>
> It makes it harder for *valid* uses of security problem discovery. It
> makes it potentially illegal to try to do security research. And don't
> tell me stupid licenses and laws like that don't happen: people really
> *do* make these kinds of shortsighted decisions, to "protect" themselves
> from bad people.

in fact there was news in the last week or two about a law in Germany that 
does exactly this. it outlaws all programs that can be used for hacking 
systems.

David Lang

