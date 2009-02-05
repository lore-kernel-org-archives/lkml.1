Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZBEQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZBEQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZBEQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:58:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbZBEQ6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:58:09 -0500
Date: Thu, 5 Feb 2009 17:57:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: style fascism for xen assemblies
Message-ID: <20090205165748.GB15490@elte.hu>
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com> <20090205150028.GD23903@elte.hu> <498B0E13.7060604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B0E13.7060604@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Impact: style cleanup
> 
> Make the following sytle cleanups.
> 
> * drop unnecessary //#include from xen-asm_32.S
> * compulsive adding of space after comma
> * reformat multiline comments
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Committed to #tj-upstream.  Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> to receive the modpost fix and this one.

pulled, thanks Tejun. (I have amended the cleanups - there was a typo in the 
changelog and a few places were missing.)

	Ingo
