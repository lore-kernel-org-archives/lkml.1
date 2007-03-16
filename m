Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXCPJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXCPJ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXCPJ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:28:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXCPJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:28:33 -0400
Date: Fri, 16 Mar 2007 10:27:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-arch@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 09/26] Xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME, define no-op architecture implementations
Message-ID: <20070316092736.GO23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232527.362011844@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232527.362011844@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> akpm:
> > Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
> > not in cpp) in the appropriate include/asm-foo/ files?

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
