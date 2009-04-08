Return-Path: <linux-kernel-owner+w=401wt.eu-S1763753AbZDHMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763753AbZDHMOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbZDHMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:05:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbZDHMFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:05:16 -0400
Date: Wed, 8 Apr 2009 14:04:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Diego Calleja <diegocg@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090408120440.GD768@elte.hu>
References: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com> <20090407103611.GA5910@elte.hu> <200904071610.47462.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200904071610.47462.diegocg@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Diego Calleja <diegocg@gmail.com> wrote:

> On Martes 07 Abril 2009 12:36:11 Ingo Molnar escribió:
> > Since besides myself i'm not aware of any other person on this 
> > planet actually _booting_ allyes/allmod Linux kernels, i guess this 
> > is not a big issue anyway :-)
> 
> IIRC once I tried to boot an allyes kernel and it oopsed, because 
> (i think) the probing routines of some drivers have never been 
> tested in machines that do not have the corresponding hardware. So 
> I doubt someoneone is using it ;)

Yes, i mapped those out gradually and disabled them. I've been 
test-booting such allyesconfig 32-bit and 64-bit kernels ever since 
then - for the past 2 years or so.

	Ingo
