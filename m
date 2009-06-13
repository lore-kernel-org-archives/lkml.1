Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbZFMAjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbZFMAjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZFMAiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:38:51 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:52295 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709AbZFMAiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:38:51 -0400
Date: Sat, 13 Jun 2009 01:38:49 +0100
From: Ben Dooks <ben@fluff.org>
To: David Miller <davem@davemloft.net>
Cc: linux@arm.linux.org.uk, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ibm@android.com,
       swetland@google.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090613003849.GC20442@fluff.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <20090611.000219.206893038.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611.000219.206893038.davem@davemloft.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 12:02:19AM -0700, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Wed, 10 Jun 2009 20:48:52 +0100
> 
> > In short not as far as I know, and I'm very disappointed with the state
> > of affairs with google.
> 
> And of course, this whole android situation has absolutely nothing to
> do with how much of a pain in that ass you are to deal with as ARM
> maintainer.

If you mean 'pain' as 'having standards', then you're probably right.
I bet some of the moaning is coming from the people who seem to expect
that since they've written some cess-pool which sort of works for
their specific case (a number of vendors fit this category) then they
have some right to expect it to be merged into mainline.

What's worse is that often trying to convince the vendors that their
paritcualy pile of sick is in need of work either gets ignored by the
management or if taken in by the techies, is often lost as a these
'porting' teams are often disbanded or moved onto something else by
the time the next task comes around.

If it wasn't for people with some form of standards devoting their
time to trying to keep the tide of evil that some of these companies
try to perpetrate out of the kernel, we'd be swimming in an
unmanagable mess by now.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
