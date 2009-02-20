Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZBTMi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZBTMi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBTMiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:38:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbZBTMiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:38:19 -0500
Date: Fri, 20 Feb 2009 13:37:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: mingo@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IA64: cast has a higher precedence than '?'
Message-ID: <20090220123753.GC26418@elte.hu>
References: <499E9C71.3050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499E9C71.3050003@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0374]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h

btw., the subject line is wrong	- this is not an ia64 patch but	
an x86 patch.

	Ingo
