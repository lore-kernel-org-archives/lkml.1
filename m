Return-Path: <linux-kernel-owner+w=401wt.eu-S1765030AbYBANME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765030AbYBANME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbYBANLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:11:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbYBANLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:11:53 -0500
Date: Fri, 1 Feb 2008 14:11:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201131139.GA4108@elte.hu>
References: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Change latencytop Kconfig entry so it doesn't list the archictectures 
> that support it. Instead introduce HAVE_LATENCY_SUPPORT which any 
> architecture can set. Should reduce patch conflicts.

thanks, applied.

	Ingo
