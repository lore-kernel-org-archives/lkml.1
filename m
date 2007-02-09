Return-Path: <linux-kernel-owner+w=401wt.eu-S2992808AbXBIUaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992808AbXBIUaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992807AbXBIUaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:30:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423291AbXBIUap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:30:45 -0500
Date: Fri, 9 Feb 2007 12:30:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jos poortvliet <jos@mijnkamer.nl>
Cc: ck@vds.kolivas.org, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: Swap prefetch merge plans
Message-Id: <20070209123029.633934eb.akpm@linux-foundation.org>
In-Reply-To: <200702091413.06949.jos@mijnkamer.nl>
References: <200702091038.37143.kernel@kolivas.org>
	<200702092054.10232.ocilent1@gmail.com>
	<200702092321.20615.kernel@kolivas.org>
	<200702091413.06949.jos@mijnkamer.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 14:13:03 +0100
jos poortvliet <jos@mijnkamer.nl> wrote:

> Nick's comment, replying to me some time ago:

I think I was thinking of this:

	http://lkml.org/lkml/2006/2/6/509

> Is there 
> something fundamentally wrong with the kernel-hackers-culture, or are these 
> incidents?

Well yes, there are incidents.  We have too many coders and not enough
reviewers, testers and bug-fixers.

If I had two solid days to sit down and carefully review, test,
try-to-exploit and if necessary improve/fix this code then perhaps we'd get
there.  But I'm nowhere vaguely near being able to afford that time and
things are just sitting there.


I have an email sitting in my drafts folder stating that I'll no longer
accept any features unless they've been publically reviewed in detail and
run-time tested by a third party.  The idea being to force people to spend
more time reviewing and testing each other's stuff and less time writing
new stuff.  Maybe on a sufficiently gloomy day I'll actually send it.

