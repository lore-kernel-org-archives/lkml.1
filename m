Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXKISp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXKISp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXKISpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:45:18 -0500
Received: from www.tglx.de ([62.245.132.106]:40058 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXKISpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:45:17 -0500
Date: Fri, 9 Nov 2007 19:45:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
In-Reply-To: <20071109183602.GD1988@alberich.amd.com>
Message-ID: <alpine.LRH.0.999.0711091943030.1196@www.tglx.de>
References: <11943900793940-git-send-email-sam@ravnborg.org>
 <20071106230451.GA10886@uranus.ravnborg.org>
 <20071109183602.GD1988@alberich.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Fri, 9 Nov 2007, Andreas Herrmann wrote:
> 
> PS: Looking forward to test the ARCH=x86 enabled kbuild.
> BTW, what is the right git tree to pull this stuff from?
> Is it your x86.git tree? But that one is not up to date, is it?

I'm working on an update. I pull Sams changes in, so we have all the
stuff in one place. It goes to mm from there so we get more test
coverage before we put all that into .25.

Thanks,
	tglx

