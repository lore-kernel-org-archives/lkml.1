Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYJVGXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYJVGXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYJVGXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:23:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJVGXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:23:45 -0400
Date: Wed, 22 Oct 2008 08:23:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86: Add UV reserved page bios call
Message-ID: <20081022062338.GE651@elte.hu>
References: <20081021200128.GE32545@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021200128.GE32545@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> Add UV bios call to get the address of the reserved page.

> +	UV_BIOS_GET_PARTITION_ADDR

> +	BIOS_STATUS_MORE_PASSES		=  1,

what is the "reserved page"?

And why is it called "PARTITION_ADDR" in the enum?

	Ingo
