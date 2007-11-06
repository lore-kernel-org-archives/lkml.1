Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbXKFXDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbXKFXDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXKFXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:03:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56514 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbXKFXDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:03:12 -0500
Date: Wed, 7 Nov 2007 00:04:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071106230451.GA10886@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11943900793940-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of patches unify the X86 Kconfig files.
Next step is to enable use of "make ARCH=x86" and kill
"make ARCH=i386/x86_64".
But that will wait till tomorrow.

The allmodconfig kernel is still building here.
Testing / reviews appreciated.

Comments from former patchset is addressed - see
changelog entries.

	Sam
