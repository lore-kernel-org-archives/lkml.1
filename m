Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXLNSMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXLNSMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbXLNSMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:12:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXLNSMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:12:15 -0500
Date: Fri, 14 Dec 2007 19:11:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       John Linville <linville@tuxdriver.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214181109.GA32350@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712141409.00311.mb@bu3sch.de> <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com> <200712141749.33708.mb@bu3sch.de> <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ray Lee <ray-lk@madrabbit.org> wrote:

> Now I'm going to go off, sit in the sun, sip some coffee, and think 
> happy thoughts of kittens playing with yarn for a while.

ok, and given the time-shift and apparent season-shift i'll sit in the 
evening, watch the snowfall and think happy thoughts of kittens fetching 
nuclear-tipped uzis and hunting ueber-elite wireless developers to beat 
some humanity and compassion into them, ok? ;-)

	Ingo
