Return-Path: <linux-kernel-owner+w=401wt.eu-S1423146AbXD3Hye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423146AbXD3Hye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423148AbXD3Hye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:54:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:54082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1423146AbXD3Hyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:54:33 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX19QXnEFQi1QpmZSeg5n+xYcLJ7ZKwxcguMnQu+kyH
	xEBjpYYg6JmLq5
Date: Mon, 30 Apr 2007 09:54:29 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Indan Zupancic <indan@nul.nu>
Cc: Johannes Stezenbach <js@linuxtv.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430075429.GB27563@merlin.emma.line.org>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Johannes Stezenbach <js@linuxtv.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <20070429223649.GA12672@linuxtv.org> <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Indan Zupancic wrote:

> I don't know, but what about telling the hapless person who went
> through the process of posting a bug what's wrong with the bug report?

It's a tedious process you keep doing over and over and over and over again,
and my experience shows it's sheer luck if people can actually fill in
the missing bits given the list.

Usually you have to ask thrice to obtain even the most essential
information such as version. Let alone vendor patches.

Anyways, the solution to this problem is someone _politely_ asking
reporters to provide necessary information and also point out that they
cannot ever hope to have their bug fixed without making a best-effort
attempt at answering all questions the first time they're being asked.

There are notable exceptions, people pinpointing code fragments at fault
and everything, but those are usually tech people and not end users.

> That said, if someone is an obvious idiot, ignoring saves time. But I
> think that's quite rare, and in general you should give the reporter
> feedback, and then ignore the bug report. (Until it improves.)

And that is what happens all too often (not in absolute figures, but in
the developer's perception of it) - insufficient information to debug.

Yes I know, some of the bugs hide themselves so well you actually need
four or five reports by different people to actually pinpoint the bug,
perhaps accompanied by insufficient interface documentation that make it
difficult to verify assumptions/expectations or assess potential
solutions (such as the res_init() issue in fetchmail, or probably the khubd going
south issue in Linux), but that's not the point.

-- 
Matthias Andree
