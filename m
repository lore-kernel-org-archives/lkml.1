Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXCEOTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXCEOTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933453AbXCEOTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:19:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXCEOTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:19:14 -0500
Date: Mon, 5 Mar 2007 15:10:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305141023.GC9146@elte.hu>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305142820.GD22829@bingen.suse.de> <20070305134854.GA31542@elte.hu> <20070305145847.GH22829@bingen.suse.de> <20070305135918.GA32380@elte.hu> <45EC24CA.1020707@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC24CA.1020707@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> kvm paravirt is only used by developers at this time.  I don't have a 
> problem with solving this in the 2.6.22 timeframe.

oh, certainly, with a KVM hat on i'd agree. But i also have my 
cares-about-i386-arch-cleanliness and cares-about-Linux-maintainability 
hats on ;-) I only mentioned KVM as an example that it /can/ be done 
cleanly.

	Ingo
