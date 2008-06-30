Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbYF3S4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbYF3S4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYF3S4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:56:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYF3S4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:56:24 -0400
Date: Mon, 30 Jun 2008 20:56:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86_64/paravirt: fix compile errors with
	IA32_EMULATION off
Message-ID: <20080630185608.GC27398@elte.hu>
References: <486921AD.8010409@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486921AD.8010409@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0995]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/xen-64bit, thanks Jeremy.

	Ingo
