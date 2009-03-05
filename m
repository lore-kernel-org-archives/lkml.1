Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZCEV3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZCEV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZCEV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:29:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZCEV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:29:26 -0500
Date: Thu, 5 Mar 2009 16:29:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Christoph Hellwig <hch@lst.de>, Felix Blyakher <felixb@sgi.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 3/3 v2] xfs: include header files for prototypes
Message-ID: <20090305212920.GA1883@infradead.org>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net> <20090304183418.525.22262.stgit@f10box.hanneseder.net> <20090305133917.GC14854@lst.de> <20090305141912.22775.64010.stgit@f10box.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305141912.22775.64010.stgit@f10box.hanneseder.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:20:25PM +0100, Hannes Eder wrote:
> I still treat this as a Acked-by: ... Ok?

Should be a review, as far as you can review these sort of patches..

> hm. but that way it is still included before xfs_mount.h.

Sure, but the point is entirely the comment which describes the block
of includes below.
