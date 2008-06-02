Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYFBK5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYFBK5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYFBK5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:57:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYFBK5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:57:34 -0400
Date: Mon, 2 Jun 2008 12:57:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: akpm@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] - Update macros used by UV platform
Message-ID: <20080602105705.GA14598@elte.hu>
References: <20080528145118.GA8614@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528145118.GA8614@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1951]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Update the UV address macros to better describe the fields of UV 
> physical addresses. Improve comments in the header files. Add 
> additional MMR definitions.

applied to tip/x86/irq - thanks Jack.

	Ingo
