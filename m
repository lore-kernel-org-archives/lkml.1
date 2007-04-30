Return-Path: <linux-kernel-owner+w=401wt.eu-S1161615AbXD3FrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161615AbXD3FrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161648AbXD3FrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:47:16 -0400
Received: from 1wt.eu ([62.212.114.60]:2429 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161615AbXD3FrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:47:15 -0400
Date: Mon, 30 Apr 2007 07:43:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430054306.GW943@1wt.eu>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429173725.GB30248@one.firstfloor.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 07:37:25PM +0200, Andi Kleen wrote:
> > My personal experience with bugzilla is that it's very unfriendly to
> > reporters.  IMHO it's suitable for tracking unresolved problems along with
> > debug patches, system information etc., but not for _reporting_ new ones.
> 
> What did you find unfriendly? 

It is too much complicated for new reporters.

I remember I sent a patch by mail for NTP to people at ISC, and they asked
me to pass through bugzilla because it was important for them to track it.
What initially was a 5 minutes email turned to a 30 minutes nightmare with
doubts at every click, and it was even difficult for me to attach the patch.

Later they replied to me by mail, which I consulted from another address, I
replied and was rejected because it was not the same address... I had to be
very very motivated to use such a crap.

Definitely the tool we need if we want to reduce the number of bug reports!

Just my experience as a bug reporter...

Willy

