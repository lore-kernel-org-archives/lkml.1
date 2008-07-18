Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbYGRMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbYGRMST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYGRMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:18:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGRMSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:18:09 -0400
Date: Fri, 18 Jul 2008 14:17:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] -tip x86/apic helper for further merging
Message-ID: <20080718121754.GK6875@elte.hu>
References: <487cd9a9.08074e0a.1dd7.20cd@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487cd9a9.08074e0a.1dd7.20cd@mx.google.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>   Hi, these two patches add calibrate_APIC_clock in 32bit code as we 
> have in 64bit code and make it to return error. I don't see the way to 
> make it simplier by now since 32bit code uses a few clock sources.
> 
>   Also this contains already passed patch
> 
> 	[RFC] lapic calibration results fix 
> 	http://lkml.org/lkml/2008/7/13/50
> 
>   Please review, any comments are welcome.

applied to tip/x86/apic, thanks Cyrill.

	Ingo
