Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXDZHr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXDZHr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXDZHr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:47:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34448 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933165AbXDZHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:47:55 -0400
Message-Id: <1177573674.23815.1186653531@webmail.messagingengine.com>
X-Sasl-Enc: xNoOKbUfF08LK2gsQ7csh2USE9hH3JdVCvjpouuQqzP9 1177573674
From: lkml777@123mail.org
To: lkml777@123mail.org, "Edward Shishkin" <edward@namesys.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>
Cc: "Alex Zarochentsev" <zam@namesys.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Eric Hopper" <hopper@omnifarious.org>, "Lex Lyamin" <flx@msu.ru>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Rik van Riel" <riel@redhat.com>, "Xu CanHao" <xucanhao@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
   <462E17AF.7090604@namesys.com>
   <1177459922.31000.1186391425@webmail.messagingengine.com>
Subject: Re: Question about Reiser4
In-Reply-To: <1177459922.31000.1186391425@webmail.messagingengine.com>
Date: Thu, 26 Apr 2007 00:47:54 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric, anyone home?

> On Tue, 2007-04-24 at 17:12 -0700, lkml777@123mail.org wrote:
> > On Sun, 22 Apr 2007 19:00:46 -0700, "Eric Hopper"
> > > <hopper@omnifarious.org> said:
> > 
> > > I did.  That whole thread is some guy spouting off a ludicrous Bonnie++
> > > benchmark showing that compressing long strings of 0s results in things
> > > taking up very little space and being very fast.
> > 
> > I think you are deliberately being stupid here.
> > 
> > You are claiming that REISER4's good speed results when using
> > compression actually has a simple explanation and THEREFORE all good
> > result for the filesystem, even those results that have nothing to do
> > with compression, are negated.
> 
> I am claiming nothing of the sort. You are assuming that I'm claiming
> this for some random reason.  And in so doing, you are hurting your
> cause and mine.

Yes you are. Your claim may have only been implicit, but it was also
VERY clear.

You complain that Reiser4's excellent speed results when using
compression might have a simple explanation. 

You then implicitly write off the whole set of results on this basis,
which is just plain dishonest.

You could have pointed out that most of the results did NOT use
compression, but instead you just ignored them.

You could have asked by how much, bonnie++'s use of files that are
mainly zeroes, affected the excellent speeds.

But you didn't, because you weren't really interested.

You ignored about 90% of the benchmarks and concentrated on a very small
area that you could raise a question about.

That is not someone looking for the truth. That is a propagandist
working against Reiser4.

Your conclusion was that of someone who is trying to destroy Reiser4,
while PRETENDING to support it.

Well. At least that is what it looks like to me.

> and ranting about how everybody is ignoring all the good parts of it and
> focusing on the bad parts makes things even worse.

Yes YOU are ignoring all the good parts of it and focusing on the (well
not bad parts but) parts that seem too good to be true.
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

