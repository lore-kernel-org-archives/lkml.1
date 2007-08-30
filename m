Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbXH3WOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbXH3WOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXH3WOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:14:44 -0400
Received: from [212.12.190.123] ([212.12.190.123]:33122 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755093AbXH3WOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:14:33 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Natalie Protasevich" <protasnb@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Who wants to maintain KR list for stable releases?
Date: Fri, 31 Aug 2007 01:11:32 +0300
User-Agent: KMail/1.5
Cc: "Adrian Bunk" <bunk@kernel.org>, "David Rees" <drees76@gmail.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?iso-8859-1?q?Bj=F6rn?= Steinbrink" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
References: <46CDE94A.7000600@googlemail.com> <46D6E135.8000203@s5r6.in-berlin.de> <32209efe0708300950r5787402l4d02cedd862314fd@mail.gmail.com>
In-Reply-To: <32209efe0708300950r5787402l4d02cedd862314fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-7"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708310111.32132.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Natalie Protasevich wrote:
> On 8/30/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > Al Boldi wrote in "Designers and Builders (was: Who wants to maintain KR
> > list for stable releases?)":
> > | So, what's wrong with tapping into people's design suggestions, and
> > | allowing others to implement it?
> >
> > Design suggestions should really come from people who also know a lot
> > about the how-to.  This is even true to some degree about feature
> > requests.  Besides, I've got a feeling that regardless of the field of
> > τεχνη one works in, someone can only be a truly good designer if she or
> > he has also been a builder.
>
> Sometimes you can feel that the suggestion comes from Unix veteran, or
> one who does a lot of linux programming in user land. Their opinion is
> often valuable.

Exactly right.

The important part in designing isn't the how-to but rather understanding the 
concepts involved.  Once you have the concepts straight, implementation 
becomes a matter of which path to take.

> > But back to the discussion.  A tracker is not a good tool for
> > brainstorming sessions, except perhaps for capturing conclusions after
> > the brainstorm, as far as they are suitable as input for actual work.
> >
> > Also, "*allowing* others to implement it" has a strange ring to me.
> > Where I am around, there are always far too few people who fix things
> > and build things.  But very, very occasionally there is someone new who
> > wonders if there is an interesting TODO item which is perhaps in the
> > reach of his abilities.  Contributing a cleanup or an actual feature is
> > typically much easier than fixing an open, tracked bug.  (The bugs which
> > end up in the bugtracker are usually the difficult ones.)  The
> > contributor learns something and, in a rare turn of events, may
> > eventually become able and willing to join the bugfixing.
>
> Yes, indeed, one should really know the code in and out to do things
> right. OTOH, not everyone has time to fix bugs in his department, or
> it's just single person trying to handle all work. I suggest that in
> this case our masters could first outline what needs to be done and
> write it down in the bugzilla. This will 1) give a warm feeling to
> reporter and everyone else that the problem is noticed and not taken
> lightly and 2) give people with active and curious minds chance to try
> solving a problem (my guess that would be many reporters themselves,
> they often ask "what can I do and how can I fix this" and some more
> junior developers looking for useful exercise and just need
> directions.) At least some good debugging will come out of it, and no
> harm...

Agreed.  But when I responded to this thread by changing the subject, because 
I felt it was somewhat OT to tracking, I meant to question the mentality of 
trying to nullify design suggestions for the mere reason of not submitting a 
prototype.  Now, prototyping is a great way to refine your end-product, but 
it's a terrible waste of time in terms of articulating design-goals.

IMHO, in the interest of keeping ahead of the competition, we should 
encourage people to express their design suggestions instead of discouraging 
them.


Thanks!

--
Al

