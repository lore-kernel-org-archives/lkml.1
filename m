Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXJZGNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXJZGNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXJZGMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:12:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56825 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXJZGMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:12:52 -0400
Date: Fri, 26 Oct 2007 08:14:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86 directory
Message-ID: <20071026061425.GA19022@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <20071025200546.GF14501@uranus.ravnborg.org> <86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com> <20071025194653.46d39a13.rdunlap@xenotime.net> <86802c440710252251v1ad07c12x22254c1b4ed3ceee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710252251v1ad07c12x22254c1b4ed3ceee@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> but
> in git
> 
> http://git.kernel.org/?p=linux/kernel/git/sam/x86.git;a=commitdiff;h=d013a27cb79a01b324f93adb275162c244cca2de
> 
> doesn't include that removing..

That's the bug Kay noticed.
It should not have been removed so I fixedit and pushed out a new change.
Again - please see reply to Kay and read the [GIT PULL] mail.

	Sam
