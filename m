Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYFJKha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYFJKha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYFJKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:37:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYFJKhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:37:19 -0400
Date: Tue, 10 Jun 2008 12:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 2/2] x86: io-apic - use predefined names instead of
	numeric constants
Message-ID: <20080610103650.GL19136@elte.hu>
References: <20080607155355.010786004@gmail.com>> <484aafc1.0c58560a.4018.6edc@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484aafc1.0c58560a.4018.6edc@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch replaces some hard-coded numbers with predefined names.

applied to tip/x86/apic, thanks.

	Ingo
