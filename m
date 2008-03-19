Return-Path: <linux-kernel-owner+w=401wt.eu-S1162289AbYCSWrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162289AbYCSWrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936766AbYCSVQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:16:33 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55494 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936758AbYCSVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:16:31 -0400
Date: Wed, 19 Mar 2008 18:35:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH 0/79] smpboot integration
Message-ID: <20080319173533.GA31576@elte.hu>
References: <12059475744092-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12059475744092-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> Testing and bisectability:
> 
> The end result was tested in all my hardware (which includes qemu ;-). 
> It does not mean it will boot _your_ hardware, but I did my best ;-)
> 
> The tree at least compiles in more than 20 randconfigs (for each of 
> x86_64 and i386) For i386, each of the subarchitectures was compiled 
> at least once. (By compile, I obviously mean, every patch, 
> individually)

very nice work! I'll pick it up - and i'm not too worried about 
breakages because at 80 patches granularity any problem should be 
identifiable in a very finegrained way.

	Ingo
