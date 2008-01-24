Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAXQA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAXQA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYAXQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:00:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYAXQAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:00:21 -0500
Date: Thu, 24 Jan 2008 16:59:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: add percpu, cpu_to_node debug options
Message-ID: <20080124155938.GC4857@elte.hu>
References: <20080122230409.198261000@sgi.com> <20080122230409.514557000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122230409.514557000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> +config THREAD_ORDER
> +	int "Kernel stack size (in page order)"
> +	range 1 3
> +	depends on X86_64
> +	default "3" if X86_SMP
> +	default "1"
> +	help
> +	  Increases kernel stack size.

you keep sending this broken portion, please dont ... 

	Ingo
