Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYGaPLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYGaPLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYGaPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:11:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYGaPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:11:15 -0400
Date: Thu, 31 Jul 2008 17:10:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: fix allocation and use of large ldts
Message-ID: <20080731151055.GA32173@elte.hu>
References: <488C97FE.2010606@goop.org> <20080728122648.GC5515@elte.hu> <488E2D28.9060602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E2D28.9060602@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Thanks.  Here's a follow-up tidy patch.
>
> Subject: xen: tidy up ldt fixes
>
> Add a proper comment for set_aliased_prot() and fix an unsigned 
> long/void * warning.

applied to tip/x86/xen - thanks Jeremy.

	Ingo
