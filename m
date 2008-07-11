Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYGKNrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYGKNrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYGKNqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:46:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYGKNqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:46:51 -0400
Date: Fri, 11 Jul 2008 15:46:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1a/2] x86_64: vdso32 cleanup using feature flags
Message-ID: <20080711134631.GA32159@elte.hu>
References: <487699D0.4030508@goop.org> <4876B3C0.1070903@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876B3C0.1070903@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Use the X86_FEATURE_SYSENTER32 to remove hard-coded CPU vendor check.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

nice cleanup - applied these two to tip/x86/core.

	Ingo
