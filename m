Return-Path: <linux-kernel-owner+w=401wt.eu-S1764605AbYASEmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764605AbYASEmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762389AbYASEl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:41:58 -0500
Received: from waste.org ([66.93.16.53]:58230 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762019AbYASEl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:41:57 -0500
Subject: Re: PROBLEM: Celeron Core
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chodorenko Michail <misha@one.by>, linux-kernel@vger.kernel.org
In-Reply-To: <20080119042750.GA24481@one.firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by>
	 <p73prvyalfl.fsf@bingen.suse.de>
	 <1200702477.25782.41.camel@cinder.waste.org>
	 <20080119011506.GA23798@one.firstfloor.org>
	 <1200715842.25782.95.camel@cinder.waste.org>
	 <20080119042750.GA24481@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 22:40:35 -0600
Message-Id: <1200717635.25782.107.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 05:27 +0100, Andi Kleen wrote:
> > So while throttling may be less efficient in terms of watt seconds used
> > to compile something than running at full speed, it is incorrect to say
> > it uses less power. One machine running for an hour throttled to 50%
> > uses less power (and therefore less battery and cooling) than another
> > running at full speed for that same hour.
> 
> Not for the same unit of work. If you just run endless loops you 
> might be true, but most systems don't do that. 

Yes, most systems idle.

> In terms of laptops (or rather in most other systems too) you usually care 
> about battery life time while the system is mostly idling (waiting
> for your key strokes etc.). In this case enabling throttling
> as a cpufreq driver will not make your battery last longer.

It will relative to not throttling.

You made a claim that is -physically impossible- as stated, a claim I've
seen here before and I'm correcting it. If something reduces heat, it
must save power *by the definition of heat and power*. And if you reduce
power usage, you will make your battery last longer.

Make any other statement you want about the efficiency of throttling per
unit work or the effectiveness of throttling relavite to other methods,
just stop repeating the claim that "throttling reduces heat but doesn't
save power". It goes against the law of conservation of energy.

-- 
Mathematics is the supreme nostalgia of our time.

