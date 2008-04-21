Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYDUMyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYDUMyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYDUMy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:54:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33114 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbYDUMy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:54:27 -0400
Date: Mon, 21 Apr 2008 14:54:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 00/10] x86: cleanup patches
Message-ID: <20080421125411.GG9554@elte.hu>
References: <480a0a62.1abd600a.2e2c.0d80@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480a0a62.1abd600a.2e2c.0d80@mx.google.com>
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


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This is the collection of clean up patch for x86.
> These patches can be applied to the latest x86.git.
> 
> 1-3: cleanup mpparse.c
> 4: cleanup alloc_bootmem() usage
> 5: cleanup clocksource_hz2mult() usage
> 6: cleanup div_sc() usage
> 7: use cpumask functions
> 8-10: propagate the use of get_bios_ebda()

applied, thanks - very nice cleanups!

	Ingo
