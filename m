Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZDOUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZDOUJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZDOUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:09:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbZDOUJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:09:23 -0400
Date: Wed, 15 Apr 2009 22:08:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] x86: used used_vectors in init_IRQ
Message-ID: <20090415200823.GB12202@elte.hu>
References: <49E62DFD.6010904@kernel.org> <20090415192550.GA27004@elte.hu> <49E636F2.7030902@kernel.org> <20090415193827.GB32675@elte.hu> <49E6397D.1020201@kernel.org> <20090415194705.GA8290@elte.hu> <49E63D4F.7080304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E63D4F.7080304@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> it is werid...
> 
> original patch is right, it seem git merge mess it up again.

Yes - as i said it in this discussion, i had to do a few ugly 
conflict resolutions - and the bug might have been introduced there.

	Ingo
