Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbYANMrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbYANMrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbYANMq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:46:58 -0500
Received: from khc.piap.pl ([195.187.100.11]:41659 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYANMq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:46:58 -0500
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <20080110131659.GF10230@mit.edu>
	<20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	<20080112150621.GC6751@mit.edu>
	<20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	<20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	<20080113231150.GB23906@mit.edu>
	<20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	<1200303743.24517.6.camel@tara.firmix.at>
	<slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
	<m3d4s4yb4s.fsf@maximus.localdomain>
	<20080114110328.GA29126@jolt.modeemi.cs.tut.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 14 Jan 2008 13:46:56 +0100
In-Reply-To: <20080114110328.GA29126@jolt.modeemi.cs.tut.fi> (Tuomo Valkonen's message of "Mon\, 14 Jan 2008 13\:03\:28 +0200")
Message-ID: <m3myr8vakf.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuomo Valkonen <tuomov@iki.fi> writes:

>> So why don't you fix it first? Correct system time is essential.
>
> I've tried tuning it with adjtimex and everything, and sometimes it
> works for days, but then just suddenly the clock starts advancing.

Nothing will make it work reliably if the system clock isn't stable.

> As I have stated earlier, upgrading Linux has become too painful by
> compiling from source,

It works for me.

> and the distros provide even worse crap as 
> their stock kernels.

That works for me, too.


The remaining options are c) to live with present situation, and
d) to give up using Linux (computers etc).

Or maybe e) to get a motherboard which isn't broken (with the kernel
you want to use).
-- 
Krzysztof Halasa
