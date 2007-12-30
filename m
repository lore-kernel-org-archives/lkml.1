Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXL3VTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXL3VTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXL3VT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:19:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57737 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXL3VT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:19:27 -0500
Date: Sun, 30 Dec 2007 22:19:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - RFC] x86: unify arch/x86/kernel/Makefile(s)
Message-ID: <20071230211927.GB14386@uranus.ravnborg.org>
References: <20071230082952.GA12327@uranus.ravnborg.org> <20071230145517.GT16946@elte.hu> <20071230150602.GU16946@elte.hu> <20071230161041.GA27370@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230161041.GA27370@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 05:10:41PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i've added your full patch meanwhile - maybe we can get away with it.
> 
> i needed the trivial fix below. You did not test-build it on 32-bit it 
> appears :-)

Had CONFIG_X86_GENERICARCH defined so I did not hit this one - sorry.
Thanks for fixing it up.

	Sam
