Return-Path: <linux-kernel-owner+w=401wt.eu-S1765886AbXJSLw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765886AbXJSLw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbXJSLwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:52:49 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3854 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbXJSLws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:52:48 -0400
Date: Fri, 19 Oct 2007 13:52:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, bryan.wu@analog.com,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin I2C/TWI driver: update for 2.6.24 merge 
 windows
Message-ID: <20071019135245.1c482589@hyperion.delvare>
In-Reply-To: <20071019022334.8e88e285.akpm@linux-foundation.org>
References: <1192456403.6215.5.camel@roc-laptop>
	<386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com>
	<20071019110750.33f66dd8@hyperion.delvare>
	<20071019022334.8e88e285.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 19 Oct 2007 02:23:34 -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2007 11:07:50 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > BTW, as a rule of thumb, I am ignoring patches that are sent to the
> > LKML in addition to the i2c list. If you think that your patch is so
> > important that it has to be send to a list with over 4500 subscribers
> > that sees 120.000 messages each year, then who am I to dare to comment
> > on it?
> > 
> > If you want me to consider your patches as something that needs my
> > attention, send them to the i2c list only, do not add LKML. This is
> > general advice for everyone sending i2c patches, not just you, of
> > course.
> 
> Disagree.  I don't think there's any benefit to anyone for developers to
> hide their stuff on remote mailing lists.

Hiding? These are lists _dedicated_ to the matter.

>                                            Copying lkml increases the
> changes that someone will spot a bug or some improvement and it generally
> keeps people informed as to what's going on.

Sending spam to millions of people increases the chances than someone
will buy your product. Does it make spam a good thing?

> yeah, 120,000 messages/year.  But a lot of them are just noise.  Patches
> are important.

Lot of noise, yes. Counting 1 second on average to process posts you're
not interested in, that's 33 hours a year. This is completely insane
and that's why I unsubscribed from LKML long ago. And the situation is
only getting worse every year. You may fail to realize the problem just
because you aren't completely human ;)

> And I really don't understand this huffy attitude and putting more
> roadblocks in the way of our contributors.

Quite on the contrary, I am trying to educate people into targeting
their posts to the right lists so that they get more appropriate
responses in a shorter time.

In a world where we would have infinite work power and time would grow
on trees, I would be fine with everyone sending everything to every
mailing list. But in the real world, time spent to do one thing isn't
spent on another. If we don't learn, collectively, to target our posts
to the right people, then we end up wasting a significant amount of our
precious time.

>                                             People like Bryan are doing a
> lot of work to improve Linux and most people are (or should be) grateful
> for that and should be prepared to go the extra yard to help them.

My comment is general and absolutely not targeted at Bryan personally.
I thought it was clear. I fully agree that Bryan is a really pleasant
and easy person to work with and I do appreciate his contributions.

-- 
Jean Delvare
