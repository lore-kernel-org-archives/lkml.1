Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYHWPuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYHWPuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 11:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYHWPuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 11:50:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37787 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYHWPuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 11:50:02 -0400
Date: Sat, 23 Aug 2008 17:49:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86 MCE: Fix CPU hotplug problem with multiple
	multicore AMD CPUs
Message-ID: <20080823154911.GB21611@elte.hu>
References: <200808222223.10387.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808222223.10387.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> x86 MCE: Fix CPU hotplug problem with multiple multicore AMD CPUs

applied to tip/x86/urgent - thanks Rafael!

	Ingo
