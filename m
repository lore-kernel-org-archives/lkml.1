Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYAHJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYAHJAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYAHJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:00:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbYAHJAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:00:01 -0500
Date: Tue, 8 Jan 2008 09:59:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 3/3] dma: x86_64 allow "attributes" to be
	used by dma_map_*
Message-ID: <20080108085935.GA28049@elte.hu>
References: <20080108023947.GS23661@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108023947.GS23661@sgi.com>
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


* akepner@sgi.com <akepner@sgi.com> wrote:

> Allow dma "attributes" to be passed to dma_map_*/dma_unmap_* 
> implementations on x86_64.

btw., the x86 bits look pretty sane - once there's an agreement on how 
the attributes API should look like.

	Ingo
