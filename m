Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbYAHI31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbYAHI31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYAHI3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:29:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYAHI3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:29:18 -0500
Date: Tue, 8 Jan 2008 09:28:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixer <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, vgoyal@redhat.com,
       hbabu@us.ibm.com, kexec@lists.infradead.org
Subject: Re: [PATCH] i386: handle an initrd in highmem (version 2)
Message-ID: <20080108082816.GH31838@elte.hu>
References: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Fix crash on NUMA reported by Dhaval Giani (reported as being a kexec 
> issue.)

thanks, applied.

	Ingo
