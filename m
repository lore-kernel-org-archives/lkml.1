Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbYA3TTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbYA3TTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbYA3TS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:18:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbYA3TS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:18:56 -0500
Date: Wed, 30 Jan 2008 20:18:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Olof Johansson <olof@lixom.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130191821.GA6527@elte.hu>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu> <20080130191302.GA20008@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130191302.GA20008@lixom.net>
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


* Olof Johansson <olof@lixom.net> wrote:

> > could you try the full patchset that Travis has just sent and which 
> > i've put into x86.git, you can pull it from:
> 
> Looks ok for powerpc so far, I haven't gotten through all defconfigs 
> yet but the first ones that failed before build now. pasemi_defconfig 
> boots as well.

great, thanks!

	Ingo
