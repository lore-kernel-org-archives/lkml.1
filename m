Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXEBJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXEBJGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161000AbXEBJGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:06:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45445 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160997AbXEBJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:06:22 -0400
Date: Wed, 2 May 2007 10:06:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Message-ID: <20070502090620.GB28174@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
References: <46382055.8030203@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46382055.8030203@snapgear.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 03:23:33PM +1000, Greg Ungerer wrote:
> Hi All,
> 
> An update of the uClinux (MMU-less) code against 2.6.21.
> A lot of cleanups, and a few bug fixes.

Any chance you could split this into a few patches and send
upstream? m68knommu has gone quite badly out of sync once again.
