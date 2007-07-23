Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXGWKZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXGWKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbXGWKZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:25:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759625AbXGWKZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:25:46 -0400
Date: Mon, 23 Jul 2007 12:25:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, Doug Chapman <doug.chapman@hp.com>,
       Vasily Tarasov <vtaras@openvz.org>,
       Thierry MERLE <thierry.merle@free.fr>, v4l-dvb-maintainer@linuxtv.org,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.23-rc1: known regressions with patches
Message-ID: <20070723102502.GA11474@elte.hu>
References: <46A47940.7030801@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A47940.7030801@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject         : Regression with sys_time() speedup patch
> References      : http://lkml.org/lkml/2007/7/20/205
> Last known good : ?
> Submitter       : Takashi Iwai <tiwai@suse.de>
> Caused-By       : ?
> Handled-By      : Ingo Molnar <mingo@elte.hu>
> Patch           : http://lkml.org/lkml/2007/7/20/219
> Status          : patch available

this has been resolved in -rc1 already, by:

commit 2008220879af095d00ca27eb168a55c8595fbc0b

	Ingo 
