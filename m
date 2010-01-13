Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221Ab0AMJYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0AMJYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192Ab0AMJYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:24:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0AMJYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:24:39 -0500
Date: Wed, 13 Jan 2010 10:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: Add function retrieving node controller
 revision number
Message-ID: <20100113092433.GB6739@elte.hu>
References: <20100112210904.GA24546@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112210904.GA24546@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Add function for determining the revision id of the SGI UV
> node controller chip (HUB). This function is needed in a
> subsequent patch.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
>  arch/x86/include/asm/uv/uv_hub.h   |   12 ++++++++++++
>  arch/x86/kernel/apic/x2apic_uv_x.c |    6 ++++++
>  2 files changed, 18 insertions(+)

We'd need to see those two patches together i guess.

	Ingo
