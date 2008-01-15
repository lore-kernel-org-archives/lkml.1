Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYAOBJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYAOBJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYAOBJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:09:05 -0500
Received: from khc.piap.pl ([195.187.100.11]:56999 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYAOBJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:09:04 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <20080112150621.GC6751@mit.edu>
	<20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	<20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	<20080113231150.GB23906@mit.edu>
	<20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	<1200303743.24517.6.camel@tara.firmix.at>
	<slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
	<m3d4s4yb4s.fsf@maximus.localdomain>
	<20080114110328.GA29126@jolt.modeemi.cs.tut.fi>
	<m3myr8vakf.fsf@maximus.localdomain>
	<20080114161828.GO2310@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 15 Jan 2008 02:09:02 +0100
In-Reply-To: <20080114161828.GO2310@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Mon\, 14 Jan 2008 11\:18\:28 -0500")
Message-ID: <m3bq7nao9d.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> I remember my nforce2 board having totally insane clock behaviour back
> around 2.6.14/2.6.15 or so.  It has since been fixed in newer kernels.
> I seem to recall some ATI chipsets were even more insane than the nvidia
> at the time, with some running double speed for the system time.

Right, I remember some reports about that, probably IOAPIC or other
HPET issues. Personally never seen that. Thus the suggestion of kernel
upgrade.
-- 
Krzysztof Halasa
