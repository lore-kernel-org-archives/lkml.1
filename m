Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbXLRR2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbXLRR2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXLRR14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:27:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52483 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678AbXLRR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:27:53 -0500
Date: Tue, 18 Dec 2007 17:27:46 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: unify module_{32|64}.h
Message-ID: <20071218172746.GA6220@infradead.org>
References: <1197979470.7734.34.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197979470.7734.34.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 04:04:30AM -0800, Harvey Harrison wrote:
> +/* x86_32/64 are simple */
> +struct mod_arch_specific
> +{
> +};

<nitpick> what about just /* x86 is simple */ </nitpick>

