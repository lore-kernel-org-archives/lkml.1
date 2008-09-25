Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYIYIOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYIYIOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYIYIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:14:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYIYIOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:14:32 -0400
Date: Thu, 25 Sep 2008 10:14:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/4] x86: signal_32.c: introduce signr_convert()
Message-ID: <20080925081420.GB30349@elte.hu>
References: <48DAF315.7070700@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DAF315.7070700@ct.jp.nec.com>
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


applied your patches to tip/x86/signal:

4694d23: x86: signal_32.c: introduce macro ia32_setup_frame and ia32_setup_rt_frame
455edbc: x86: signal: introduce helper macro is_ia32
b94fd69: x86: signal_64.c: introduce helper function signr_convert()
8d8c13b: x86: signal_32.c: introduce signr_convert()

thanks! FYI, your other 13 x86 signal code unification commits and other 
x86-signals enhancements passed testing just fine so far.

	Ingo
