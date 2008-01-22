Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYAVPtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYAVPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYAVPtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:49:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYAVPtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:49:40 -0500
Date: Tue, 22 Jan 2008 16:49:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122154918.GA27006@elte.hu>
References: <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796081A.7060505@davidnewall.com>
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

> >>> You seem to be under the illusion that iBCS2 support works currently
> >>> in mainline and that only this patch would break it.
> >>>       
> >> I cannot imagine what brings you to that conclusion.  Suffice to say 
> >> you are entirely and inexplicably wrong.
> >>     
> >
> > it should be very easy for you to prove me wrong then. I've got a very 
> > simple question: please tell me, how do i run a binary compiled for an 
> > iBCS2 platform under Linux v2.6.23?
> >   
> 
> You're being silly.  Either that or you're not reading what I write. 
> You know perfectly well iBCS2 compatibility doesn't work (anymore.)  
> The question, in my mind, is will it ever be made to work again?  I 
> think the answer should be yes.

unfortunately you have not replied to my (rather clear) question. Let me 
repeat the question (which can be clearly seen in the quoted sections 
above). Andi made this assertion:

|  You seem to be under the illusion that iBCS2 support works currently 
|  in mainline and that only this patch would break it.

And you claimed that what Andi says is false:

||  I cannot imagine what brings you to that conclusion.  Suffice to say 
||  you are entirely and inexplicably wrong.

All i did was to ask your proof for why you claim that Andi is wrong - 
i.e. why you think that: "iBCS2 support works currently in mainline" is 
not an illusion. Please give me that proof or retract your statement, if 
it was done in error. v2.6.23 is the current mainline kernel.

	Ingo
