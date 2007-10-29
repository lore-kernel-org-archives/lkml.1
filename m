Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXJ2Lhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXJ2Lhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJ2Lho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:37:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXJ2Lhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:37:43 -0400
Date: Mon, 29 Oct 2007 12:37:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Message-ID: <20071029113729.GA21412@elte.hu>
References: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> On Sun, 28 Oct 2007 21:33:02 -0700, H. Peter Anvin wrote:
> > Mikael Pettersson wrote:
> > > My old 486 fails to boot with the 2.6.24-rc1 kernel.
> > > Grub loads it, 4 lines of text appear but not the kernel's
> > > "Linux version <blah> greet", and the machine reboots.
> > > Double-checked with a serial console: nothing appears
> > > before it reboots.
> > 
> > What four lines of text?
> 
> They're impossible to capture because they're only visible on the VGA 
> screen for like 0.2 seconds before the machine reboots and the screen 
> is blanked; they don't show up on the serial console.

the way i debug these is to take a digital camera and make a movie of 
the bootup, then check the movie frame for frame.

admittedly it's a pretty sick method.

	Ingo
