Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYAHX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYAHX5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYAHX5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:57:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYAHX5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:57:15 -0500
Date: Wed, 9 Jan 2008 00:57:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
Message-ID: <20080108235719.GA28353@uranus.ravnborg.org>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com> <20080108215247.GE14829@elte.hu> <20080108221722.GA27698@uranus.ravnborg.org> <20080108223554.GE21482@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108223554.GE21482@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > Firstly, anyone with a forked kernel with outstanding patches that 
> > > are not in x86.git only has themselves to blame. We want to actively 
> > > discourage forking and sitting on patches too long.
> > 
> > Curious - what is the purpose of the x86.git tree these days?
> 
> what do want to imply by 'these days'?

I wondered when you wrote "anyone with a forked kernel with outstanding
patches that are not in x86.git" if this was only x86 specific patches
or more than that. I could have a slev of patches in the works
for parts that are no x86 specific (which I unfortunately do not have).

	Sam
