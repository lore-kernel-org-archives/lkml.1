Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYBTI1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYBTI1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYBTI06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:26:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYBTI05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:26:57 -0500
Date: Wed, 20 Feb 2008 09:26:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: Coding style fixes to
	arch/x86/mach-generic/bigsmp.c
Message-ID: <20080220082645.GC27036@elte.hu>
References: <20080220001852.0c3b1e40@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220001852.0c3b1e40@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> File is now error/warning free

thanks Paolo, i've picked up all your patches.

the mmx cleanup i already did in the x86.git#testing branch. (that's a 
new branch that has even fresher patches than x86.git#mm)

	Ingo
