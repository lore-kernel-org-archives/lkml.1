Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYE0WJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYE0WJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbYE0WJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:09:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbYE0WJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:09:14 -0400
Message-ID: <483C85EB.7060604@redhat.com>
Date: Tue, 27 May 2008 18:06:35 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Love Hate <love.and.hate.on.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Love and Hate on LKML
References: <89af77c70805271348y1df96afveb020d0f3f875da1@mail.gmail.com>
In-Reply-To: <89af77c70805271348y1df96afveb020d0f3f875da1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Love Hate wrote:
> Dear Developers,
> 
> At the outset I would like to thank you for your great work - IMHO Linux is the
> best OS in the Solar System.
> 
> Unfortunately, your relationships with certain people are not the best. I do not
> like how some people are treated on LKML. I will publish further episodes
> of "Love and Hate on LKML" until you change the climate around Linux
> development.
> 
> http://loveandhateonlkml.wordpress.com/
> 
> If your speech is found in some of the episodes, this means that it has
> been considered very offensive.
> 
> Kind regards

This is a classic example of a problem-seeking idea.  Quite a lot of people post 
to this list with some idea that they think will make a large impact on the 
community at large, certainly far larger than a lowly patch in a subsystem it 
would take weeks to understand.  Typically the proximal cause is sleep 
deprivation, a condition that afflicts many kernel developers and enthusiasts, 
with the result being a decreased inhibition against ideation of reference and 
ideation of grandeur.  This causes the believe that you have "discovered" 
something which is really quite well understood and is being addressed with the 
priority it is due, and that as a result of your discovery you are uniquely 
qualified to guide the community to its resolution.

I don't mean to throw stones here.  If you dig through the archives, you can 
find examples of some grandiose ideas I've posted that never resulted in a 
single line of code, or turned out to be impractical generalizations of more 
specific optimizations that have already been implemented.  Invariably these 
were posted while sleep-deprived, and I've been quite embarrassed by them the 
next morning, and relieved that for the most part they were ignored.

If not for the importance of addressing this issue, I would leave this post 
ignored as well.  I have no qualms with the goal of improving civility on LKML, 
but it's not something that's going to be solved by anonymously shaming people 
on a blog.  The goal of your blog appears to be to chastise kernel developers, 
which is at best a needless escalation of hostilities.

If you want to improve the quality of discourse here, then get involved and make 
good posts.  Email makes filtering very easy, so if someone is a troll or is 
posting on technical matters they don't understand, we can simply ignore them. 
If you want to rebuke people for particular conduct, do it on the list, so the 
people who read and post to this list can engage in a discussion of what is 
acceptable here.  The only people who will read a blog such as yours are 
malcontents looking for reasons to dismiss those who have criticized or ignored 
them.

My suggestion to you, and to everyone else who wants to improve the quality of 
this community, is to become a part of it.  Learn a subsystem.  Post patches 
that fix problems people care about.  Listen to criticism and respond to it 
constructively.  This will make your posts relevant to the list, and give you 
far more influence than a blog about a technical mailing list that has no 
technical objective.  Convincing other people to be nice is not a technical 
problem that can be resolved by one person analyzing it and implementing a 
solution in a late-night hacking/blogging session.  Quite the contrary, 
late-night hacking/blogging sessions tend to be detrimental to this goal.

-- Chris
