Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbZDHN2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbZDHN2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZDHN2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:28:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011AbZDHN23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:28:29 -0400
Date: Wed, 8 Apr 2009 15:27:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090408132746.GQ18581@elte.hu>
References: <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain> <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com> <20090407103611.GA5910@elte.hu> <1158166a0904080556n29daf102wec5689cf12b4b81f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0904080556n29daf102wec5689cf12b4b81f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi Ingo,
> 
> On Tue, Apr 7, 2009 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > allmod/allyes will enable all sorts of legacy options.
> >
> > Since besides myself i'm not aware of any other person on this
> > planet actually _booting_ allyes/allmod Linux kernels,
> 
> Does allyesconfig boot? Any funny effects?

Besides a long bootup time and a somewhat slow kernel (everything 
built in, all debug facilities, everything ...) and the need to 
filter out bad drivers first, none.

Any funny effects get fixed or reported by me ;-)

	Ingo
