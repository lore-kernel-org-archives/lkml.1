Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbXGLLvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbXGLLvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763614AbXGLLvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:51:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58641 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbXGLLvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:51:32 -0400
Date: Thu, 12 Jul 2007 12:51:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: generic irq handling
Message-ID: <20070712115120.GA29905@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
	gerg@uclinux.org, linux-kernel@vger.kernel.org
References: <200707120705.l6C75Icx014878@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707120705.l6C75Icx014878@goober>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 05:05:18PM +1000, Greg Ungerer wrote:
> Change the m68knommu irq handling to use the generic irq framework.

Nice, thanks a lot.

