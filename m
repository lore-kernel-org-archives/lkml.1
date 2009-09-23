Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZIWBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZIWBLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZIWBLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:11:38 -0400
Received: from fifo99.com ([67.223.236.141]:56716 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZIWBLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:11:38 -0400
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
 scheduling class)
From: Daniel Walker <dwalker@fifo99.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1253667708.30020.134.camel@Joe-Laptop.home>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir>
	 <1253637721.18939.3.camel@laptop>  <20090922191117.GB24542@elte.hu>
	 <1253667103.25689.35.camel@desktop>
	 <1253667708.30020.134.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:11:39 -0700
Message-Id: <1253668299.25689.44.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 18:01 -0700, Joe Perches wrote:
> On Tue, 2009-09-22 at 17:51 -0700, Daniel Walker wrote:
> > I'll stop sending those
> > emails if it's actually negative , but I don't think it is..
> 
> Hi Daniel.
> 
> I think it'd be more helpful if instead of merely sending
> a "hah! checkpatch failure!" email you send the submitter
> a gentler nudge and a fixed patch.

I don't say "hah!" like I caught you or something .. I could try to
soften the emails further so that's not the feeling .. As far as sending
fixed patches to people it's not really feasible due to the number of
patches I would have to send out.. The other issues is that if I send a
corrected patch I could become responsible for that persons patch
instead of them .. I could send out delta patches, however, I don't want
people to rely on me to fix these issues.. Ideally people would correct
them prior to sending the patches out..

Daniel

