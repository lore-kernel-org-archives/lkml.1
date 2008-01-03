Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYACKnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYACKnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYACKnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:43:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYACKnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:43:05 -0500
Date: Thu, 3 Jan 2008 11:42:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [10/20] i386: Move MWAIT idle check to generic CPU
	initialization
Message-ID: <20080103104253.GB29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005005.B13C714D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005005.B13C714D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Previously it was only run for Intel CPUs, but AMD Fam10h implements 
> MWAIT too.
> 
> This matches 64bit behaviour.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

thanks, applied.

	Ingo
