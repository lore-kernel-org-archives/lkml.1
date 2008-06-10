Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYFJKgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYFJKgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFJKgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:36:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYFJKgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:36:32 -0400
Date: Tue, 10 Jun 2008 12:36:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: io-apic - define names for redirection table
	entry fields
Message-ID: <20080610103616.GK19136@elte.hu>
References: <20080607155355.010786004@gmail.com>> <484aafc0.0407560a.301e.6a8d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484aafc0.0407560a.301e.6a8d@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Each I/O APIC redirection table entry has a number of fields. Define 
> names for them to eliminate reference by hard coded numbers.

applied to tip/x86/apic, thanks Cyrill.

	Ingo
