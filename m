Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYEWJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYEWJRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYEWJRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:17:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYEWJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:17:03 -0400
Date: Fri, 23 May 2008 05:17:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@linux.intel.com>
Subject: Re: [patch 03/14] hppfs: remove hppfs_permission
Message-ID: <20080523091701.GA27119@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171545.131855179@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521171545.131855179@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:15:01PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> hppfs_permission() is equivalent to the '.permission == NULL' case.


Looks good.

