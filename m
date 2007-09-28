Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXI1Shy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXI1Shy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXI1Shp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:37:45 -0400
Received: from verein.lst.de ([213.95.11.210]:47964 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbXI1Sho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:37:44 -0400
Date: Fri, 28 Sep 2007 20:37:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 07/10] Use path_put() in a few places instead of {mnt,d}put()
Message-ID: <20070928183741.GG14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141228.602149616@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141228.602149616@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:07PM +0200, jblunck@suse.de wrote:
> Use path_put() in a few places instead of {mnt,d}put()

Looks good.

