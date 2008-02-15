Return-Path: <linux-kernel-owner+w=401wt.eu-S1765717AbYBOBOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765717AbYBOBOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYBOBN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:13:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbYBOBN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:13:57 -0500
Date: Fri, 15 Feb 2008 02:13:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: fix kernel panic and memory leak on proc
Message-ID: <20080215011341.GA11756@elte.hu>
References: <47B4C5E7.5000802@ct.jp.nec.com> <20080214164216.45ebf51f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214164216.45ebf51f@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On Thu, 14 Feb 2008 14:51:19 -0800
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
> > Hi,
> > 
> > I posted 2 patches to fix kernel panic and memory leak.
> > http://lkml.org/lkml/2008/2/14/282
> > http://lkml.org/lkml/2008/2/14/283
> > 
> > But, I think this patch is better than old ones.

thanks Hiroshi, applied.

	Ingo
