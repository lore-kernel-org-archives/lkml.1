Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbXIIUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbXIIUjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbXIIUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:39:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbXIIUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:39:29 -0400
Date: Sun, 9 Sep 2007 21:39:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070909203920.GA11764@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
	linux-kernel@vger.kernel.org
References: <20070909202527.GT3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909202527.GT3563@stusta.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:25:28PM +0200, Adrian Bunk wrote:
> sys_{open,read} can finally be unexported.

Andrew, can you please put this in?  Having these exports for syscalls around
hsa been a long-time annoyance that can finally be fixed now.

