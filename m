Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZI3MGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZI3MGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZI3MGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:06:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZI3MGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:06:41 -0400
Date: Wed, 30 Sep 2009 14:06:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
	scheduling class)
Message-ID: <20090930120635.GF1412@ucw.cz>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir> <1253637721.18939.3.camel@laptop> <20090922191117.GB24542@elte.hu> <1253667103.25689.35.camel@desktop> <1253667708.30020.134.camel@Joe-Laptop.home> <1253668299.25689.44.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253668299.25689.44.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-22 18:11:39, Daniel Walker wrote:
> On Tue, 2009-09-22 at 18:01 -0700, Joe Perches wrote:
> > On Tue, 2009-09-22 at 17:51 -0700, Daniel Walker wrote:
> > > I'll stop sending those
> > > emails if it's actually negative , but I don't think it is..
> > 
> > Hi Daniel.
> > 
> > I think it'd be more helpful if instead of merely sending
> > a "hah! checkpatch failure!" email you send the submitter
> > a gentler nudge and a fixed patch.
> 
> I don't say "hah!" like I caught you or something .. I could try to
> soften the emails further so that's not the feeling .. As far as sending
> fixed patches to people it's not really feasible due to the number of
> patches I would have to send out.. The other issues is that if I send a

Well, so pick the worst offenders, only. That will also nicely reduce
ammount of distraction on  the list.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
