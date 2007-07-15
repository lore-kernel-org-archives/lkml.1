Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbXGOJFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbXGOJFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXGOJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:04:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59686 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbXGOJEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:04:54 -0400
Date: Sun, 15 Jul 2007 10:04:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] Text Edit Lock - Architecture Independent Code - kerneldoc
Message-ID: <20070715090449.GA15682@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070714012133.612727310@polymtl.ca> <20070714012411.845928928@polymtl.ca> <20070715012807.GA23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715012807.GA23209@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 09:28:07PM -0400, Mathieu Desnoyers wrote:
> Text Edit Lock - Architecture Independent Code - kerneldoc
> 
> Add kerneldoc to text edit lock API.

kerneldoc is placed in the implementation file, not the header.

