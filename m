Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbXLQNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbXLQNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXLQNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:43:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42298 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbXLQNnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:43:08 -0500
Date: Mon, 17 Dec 2007 14:42:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@redhat.com, olaf@aepfle.de, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64: also define AT_VECTOR_SIZE_ARCH
Message-ID: <20071217134235.GI1870@elte.hu>
References: <475D6C91.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475D6C91.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> The patch introducing this left out x86-64, despite it also having 
> extra entries.

thanks, applied. Is there any 2.6.24 urgency for this?

	Ingo
