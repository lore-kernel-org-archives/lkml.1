Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYIQJxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYIQJxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQJxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:53:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYIQJxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:53:34 -0400
Date: Wed, 17 Sep 2008 11:53:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de
Subject: Re: [PATCH] x86: print DMI information in the oops trace
Message-ID: <20080917095320.GA7040@elte.hu>
References: <20080916112730.0b57689d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916112730.0b57689d@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] x86: print DMI information in the oops trace
> 
> in order to diagnose hard system specific issues, it's useful to
> have the system name in the oops (as provided by DMI)
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

good idea - applied to tip/x86/debug, thanks Arjan.

	Ingo
