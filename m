Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYDIPMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYDIPMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYDIPMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:12:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYDIPMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:12:00 -0400
Date: Wed, 9 Apr 2008 17:11:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-ID: <20080409151135.GA25771@elte.hu>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408184301.651388000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0086]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

>   * Add cpu_sysdev_class functions to display the
> 
>   * Cleanup usages of cpumask_scprintf in the following files and add
>     another interface to use cpulist_scnprintf where appropriate.

thanks Mike, applied.

	Ingo
