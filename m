Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXL3Otj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXL3Otj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXL3Otc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:49:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXL3Otc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:49:32 -0500
Date: Sun, 30 Dec 2007 15:45:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86 makefile unification and cleaning
Message-ID: <20071230144509.GP16946@elte.hu>
References: <20071229203836.GA21020@uranus.ravnborg.org> <20071229204414.GA21219@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071229204414.GA21219@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > Patches follows.
> 
> And they all list my mail address as "sam@saturn.ravnborg.org".
> Ingo - can I ask you to manually fix it up or do you want a resend?

sure - fixed it up. I've picked up the first 4 patches of yours into 
x86.git and folded the 5th patch into the fourth.

	Ingo
