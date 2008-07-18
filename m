Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYGRLvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYGRLvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYGRLvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:51:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYGRLvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:51:17 -0400
Date: Fri, 18 Jul 2008 13:50:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: report hypervisor version
Message-ID: <20080718115059.GG6875@elte.hu>
References: <487D0BBA.8010602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0BBA.8010602@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0236]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Various versions of the hypervisor have differences in what ABIs and
> features they support.  Print some details into the boot log to help
> with remote debugging.

applied to tip/x86/xen, thanks Jeremy.

	Ingo
