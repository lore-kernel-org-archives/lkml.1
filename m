Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXDYOpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXDYOpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161195AbXDYOpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:45:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40008 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbXDYOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:45:22 -0400
Message-Id: <1177512322.14817.1186503257@webmail.messagingengine.com>
X-Sasl-Enc: Rtt7zYTuucE5GlqByx9RfqP56z16SvNRU0ax1RrO9duR 1177512322
From: lkml777@123mail.org
To: "Eric M. Hopper" <hopper@omnifarious.org>, "Theodore Tso" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <462C4858.3050006@redhat.com>
   <Pine.LNX.4.64.0704230555020.25153@server.thyself>
   <462C4D32.4000909@redhat.com>
   <Pine.LNX.4.64.0704230611430.25153@server.thyself>
   <462C5034.9090403@redhat.com>
   <Pine.LNX.4.64.0704230640540.25153@server.thyself>
   <20070423010445.454eda63.akpm@linux-foundation.org>
   <20070423135216.GA2744@omnifarious.org>
   <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com>
   <20070424001934.GC1663@thunk.org>
   <1177483176.3315.32.camel@bats.omnifarious.org>
Subject: Re: Question about Reiser4
In-Reply-To: <1177483176.3315.32.camel@bats.omnifarious.org>
Date: Wed, 25 Apr 2007 07:45:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 23:39:36 -0700, "Eric M. Hopper"
<hopper@omnifarious.org> said:
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
http://www.fastmail.fm - A no graphics, no pop-ups email service

