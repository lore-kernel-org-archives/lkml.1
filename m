Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYBYHjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYBYHjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYBYHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:39:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYBYHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:39:30 -0500
Date: Mon, 25 Feb 2008 08:38:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hskinnemoen@atmel.com,
       Masami Hiramatsu <mhiramat@redhat.com>, sam@ravnborg.org,
       sagar.abhishek@gmail.com
Subject: Re: [PATCH 1/2] Kprobes: Indicate kretprobe support in Kconfig
Message-ID: <20080225073859.GH11327@elte.hu>
References: <20080225055541.GE7148@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225055541.GE7148@in.ibm.com>
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


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This patch adds CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file 
> for relevant architectures with kprobes support. This facilitates easy 
> handling of in-kernel modules (like 
> samples/kprobes/kretprobe_example.c) that depend on kretprobes being 
> present in the kernel.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
