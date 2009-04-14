Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZDNQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZDNQXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZDNQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:23:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZDNQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:23:05 -0400
Date: Tue, 14 Apr 2009 12:23:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: xfs-masters@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 5/6] Handle possible bio_alloc failure in xfs
Message-ID: <20090414162301.GA24967@infradead.org>
References: <200904141636.45463.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904141636.45463.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 04:36:45PM +0530, Nikanth Karthikesan wrote:
> Handle bio_alloc failure in xfs.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

NAK, as already explained by Jens.

