Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZFYJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZFYJUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZFYJUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:20:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFYJU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:20:29 -0400
Date: Thu, 25 Jun 2009 11:20:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, andi@firstfloor.org,
       hpa@zytor.com, tglx@linutronix.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and
	improve lpage NUMA support
Message-ID: <20090625092011.GA23547@elte.hu>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <4A42E25B.6080102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A42E25B.6080102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Andrew Morton wrote:
>
> > The Impact: lines were useful :)
> 
> Eh.. well, it looks like it's going the way of dodo tho.

Yes. I found them useful too but some people (including Andrew ;) 
were too argumentative about it so i asked you to remove them from 
this patch-set. So yes, it's all going the way of the dodo.

And yes, i attribute the excellent stability of the x86 code in this 
cycle partly to the effect of impact lines. They really helped us be 
very conscious with dangerous changes.

	Ingo
