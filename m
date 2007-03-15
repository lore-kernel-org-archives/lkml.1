Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXCOTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXCOTSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCOTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:18:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38552 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbXCOTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:18:36 -0400
Date: Thu, 15 Mar 2007 19:18:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI DAC DMA APIs
Message-ID: <20070315191834.GA12603@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Beulich <jbeulich@novell.com>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <45F94C45.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F94C45.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:38:13PM +0000, Jan Beulich wrote:
> While the kernel headers provide for this, there don't appear to be any
> in-tree users (which seems contrary to general Linux policies). Would there
> be objections to remove all of these?

They should go away.  Having them in for more than five years without
any users is almost a guarantee for bitrot.
