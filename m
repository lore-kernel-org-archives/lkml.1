Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYCUOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYCUOq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYCUOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:46:17 -0400
Received: from www.tglx.de ([62.245.132.106]:49201 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbYCUOqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:46:16 -0400
Date: Fri, 21 Mar 2008 15:45:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: tick-common.c hack for s390 needed
In-Reply-To: <20080321132559.GA4128@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Heiko Carstens wrote:
> 
> The patch below removes at least three of the includes for a beginning.
> Still compiles on s390 and x86_64.
> 
> Subject: [PATCH] time: remove include/irq.h.
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Generic code is not supposed to include linux/irq.h.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied, thanks,

	 tglx

