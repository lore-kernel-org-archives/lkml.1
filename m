Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbYFJKTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbYFJKTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYFJKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:18:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYFJKS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:18:56 -0400
Date: Tue, 10 Jun 2008 12:18:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] : Fix unused variable 'loops' warning in
	arch/x86/boot/a20.c
Message-ID: <20080610101843.GN27706@elte.hu>
References: <ea11fea30806050644o216c798pbe88d269a63f64f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30806050644o216c798pbe88d269a63f64f2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0782]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Manish Katiyar <mkatiyar@gmail.com> wrote:

> Following patch fixes the below warning message :
> arch/x86/boot/a20.c:118: warning: unused variable 'loops'

applied to tip/x86/urgent, thanks Manish.

	Ingo
