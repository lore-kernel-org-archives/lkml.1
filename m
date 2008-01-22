Return-Path: <linux-kernel-owner+w=401wt.eu-S1751645AbYAVLMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbYAVLMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYAVLMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:12:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYAVLMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:12:22 -0500
Date: Tue, 22 Jan 2008 12:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122111205.GA25090@elte.hu>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4793F775.6090403@davidnewall.com>
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


* David Newall <davidn@davidnewall.com> wrote:

> Andi Kleen wrote:
> > You seem to be under the illusion that iBCS2 support works currently
> > in mainline and that only this patch would break it.
>
> I cannot imagine what brings you to that conclusion.  Suffice to say 
> you are entirely and inexplicably wrong.

it should be very easy for you to prove me wrong then. I've got a very 
simple question: please tell me, how do i run a binary compiled for an 
iBCS2 platform under Linux v2.6.23?

I've got plenty of v2.6.23-running testsystems, tell me, if i wanted, 
how could i run any iBCS2 binary on them? All i see is a massive, 
2.4-kernels-only patchkit:

   http://www.kernel.org/pub/linux/kernel/people/hch/linux-abi/v2.4/

which external patch-kit was not picked up by major distros and which 
was never integrated into the upstream kernel either. iBCS2 support in 
Linux 2.6 simply does not exist.

	Ingo
