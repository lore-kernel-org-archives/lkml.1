Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZB1WKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZB1WKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZB1WKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:10:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZB1WKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:10:45 -0500
Date: Sat, 28 Feb 2009 17:10:40 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 0/4] genirq: add infrastructure for threaded interrupt
	handlers V2
Message-ID: <20090228221040.GA7797@infradead.org>
References: <20090226131336.423054348@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226131336.423054348@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 01:28:02PM -0000, Thomas Gleixner wrote:
> This patch series implements support for threaded irq handlers for the
> generic IRQ layer.

What tree is this again?  Patch number two fails to apply again
mainline.

