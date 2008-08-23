Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYHWPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYHWPhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYHWPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 11:37:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYHWPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 11:37:41 -0400
Date: Sat, 23 Aug 2008 17:37:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
Message-ID: <20080823153725.GB16984@elte.hu>
References: <48AD82D5.76E4.0078.0@novell.com> <1219429418-29023-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219429418-29023-2-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Robert Richter <robert.richter@amd.com> wrote:

> Until now, PCI ECS setup was performed at boot time only and for cpus 
> that are enabled then. This patch fixes this and adds cpu hotplug.

this patch does not apply cleanly to -git.

	Ingo
