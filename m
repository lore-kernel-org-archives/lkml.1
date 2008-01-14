Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYANLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYANLDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYANLDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:03:32 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:42028 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbYANLDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:03:31 -0500
Date: Mon, 14 Jan 2008 13:03:28 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080114110328.GA29126@jolt.modeemi.cs.tut.fi>
References: <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at> <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> <m3d4s4yb4s.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <m3d4s4yb4s.fsf@maximus.localdomain>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-14 11:06 +0100, Krzysztof Halasa wrote:
> So why don't you fix it first? Correct system time is essential.

I've tried tuning it with adjtimex and everything, and sometimes it
works for days, but then just suddenly the clock starts advancing.

> I guess I would upgrade to some newer version, perhaps one which isn't
> more than two years old...

As I have stated earlier, upgrading Linux has become too painful by
compiling from source, and the distros provide even worse crap as 
their stock kernels.

-- 
Tuomo
