Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXKITk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXKITk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXKITkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:40:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53867 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbXKITkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:40:18 -0500
Date: Fri, 9 Nov 2007 20:41:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071109194156.GA3809@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071106230451.GA10886@uranus.ravnborg.org> <20071109183602.GD1988@alberich.amd.com> <alpine.LRH.0.999.0711091943030.1196@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0711091943030.1196@www.tglx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 07:45:04PM +0100, Thomas Gleixner wrote:
> Andreas,
> 
> On Fri, 9 Nov 2007, Andreas Herrmann wrote:
> > 
> > PS: Looking forward to test the ARCH=x86 enabled kbuild.
> > BTW, what is the right git tree to pull this stuff from?
> > Is it your x86.git tree? But that one is not up to date, is it?
> 
> I'm working on an update. I pull Sams changes in, so we have all the
> stuff in one place. It goes to mm from there so we get more test
> coverage before we put all that into .25.

My git tree is outdated.
I hope to have it updated with complete patchset tonight.

	Sam
