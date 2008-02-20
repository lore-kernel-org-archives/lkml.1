Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYBTJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYBTJK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYBTJKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:10:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbYBTJKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:10:36 -0500
Date: Wed, 20 Feb 2008 10:10:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, sandmann@redhat.com, tglx@tglx.de,
       hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080220091022.GB31424@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219123756.6261c13c@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Soren Sandmann <sandmann@redhat.com>
> Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> 
> The sysprof tool is a very easy to use GUI tool to find out where 
> userspace is spending CPU time. See 
> http://www.daimi.au.dk/~sandmann/sysprof/ for more information and 
> screenshots on this tool.
> 
> Sysprof needs a 200 line kernel module to do it's work, this module 
> puts some simple profiling data into debugfs.

thanks, looks good to me - applied.

	Ingo
