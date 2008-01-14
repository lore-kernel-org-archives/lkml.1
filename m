Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYANKGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYANKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYANKGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:06:31 -0500
Received: from khc.piap.pl ([195.187.100.11]:52160 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbYANKGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:06:31 -0500
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <18307.42821.166376.732473@stoffel.org>
	<slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	<871w8r6ruc.fsf@barad-dur.regala.cx>
	<slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	<20080110131659.GF10230@mit.edu>
	<20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	<20080112150621.GC6751@mit.edu>
	<20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	<20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	<20080113231150.GB23906@mit.edu>
	<20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	<1200303743.24517.6.camel@tara.firmix.at>
	<slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 14 Jan 2008 11:06:27 +0100
In-Reply-To: <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> (Tuomo Valkonen's message of "Mon, 14 Jan 2008 09:48:00 +0000 (UTC)")
Message-ID: <m3d4s4yb4s.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuomo Valkonen <tuomov@iki.fi> writes:

> It isn't, right after boot. But while the system is on, it sometimes
> starts advancing very fast, 15min a day or so.

So why don't you fix it first? Correct system time is essential.

I guess I would upgrade to some newer version, perhaps one which isn't
more than two years old...
-- 
Krzysztof Halasa
