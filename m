Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYETPnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYETPnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbYETPmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:42:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669AbYETPmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:42:36 -0400
Date: Tue, 20 May 2008 17:42:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: aperture_64: use symbolic constants
Message-ID: <20080520154215.GA15494@elte.hu>
References: <20080519123952.GA23118@elf.ucw.cz> <20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520142717.GA22794@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > * Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > Use symbolic constants in aperture_64.c where possible (and make a 
> > > comment slightly more helpful).
> > 
> > this code has already been changed in the latest -tip tree:
> > 
> >    http://people.redhat.com/mingo/tip.git/README
> > 
> > iommu/gart code is covered by the tip/x86/gart subtopic, which carries 7 
> > commits right now:
> 
> Thanks, I have a copy now. And this one is relative to it:
> 
> --- 
> 
> Factor-out common aperture_valid code.

applied, thanks Pavel.

	Ingo
