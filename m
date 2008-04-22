Return-Path: <linux-kernel-owner+w=401wt.eu-S1751074AbYDVOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbYDVOCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYDVOCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:02:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYDVOCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:02:23 -0400
Date: Tue, 22 Apr 2008 16:02:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: random clean-ups
Message-ID: <20080422140203.GB24966@elte.hu>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com> <20080421122504.GF6788@elte.hu> <90edad820804210541h26c8e66dh70895f32e4b4038d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90edad820804210541h26c8e66dh70895f32e4b4038d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0298]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> > thanks Dmitri, applied #1/#2/#4, as per the discussion.
> 
> Hi Ingo,
> 
> This should be #1, #3 and #4. The NexGen patch, which was #2 in the 
> original series, have been replaced by a bigger patch that kills 
> NexGen altogether. Plese check, if you have time for that.

yeah, i did the right thing and described the wrong selection :) You can 
check the end result via:

  http://people.redhat.com/mingo/x86.git/README

	Ingo
