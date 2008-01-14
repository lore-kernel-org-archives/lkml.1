Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYANQSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYANQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYANQS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:18:29 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56268 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414AbYANQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:18:29 -0500
Date: Mon, 14 Jan 2008 11:18:28 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080114161828.GO2310@csclub.uwaterloo.ca>
References: <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at> <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> <m3d4s4yb4s.fsf@maximus.localdomain> <20080114110328.GA29126@jolt.modeemi.cs.tut.fi> <m3myr8vakf.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3myr8vakf.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 01:46:56PM +0100, Krzysztof Halasa wrote:
> Nothing will make it work reliably if the system clock isn't stable.

I remember my nforce2 board having totally insane clock behaviour back
around 2.6.14/2.6.15 or so.  It has since been fixed in newer kernels.
I seem to recall some ATI chipsets were even more insane than the nvidia
at the time, with some running double speed for the system time.

--
Len Sorensen
