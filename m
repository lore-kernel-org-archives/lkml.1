Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZCENj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZCENj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZCENhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:50 -0500
Received: from verein.lst.de ([213.95.11.210]:46006 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbZCENhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:46 -0500
Date: Thu, 5 Mar 2009 14:37:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Felix Blyakher <felixb@sgi.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: move declaration to header file
Message-ID: <20090305133739.GA14854@lst.de>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net> <20090304183331.525.4491.stgit@f10box.hanneseder.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304183331.525.4491.stgit@f10box.hanneseder.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 07:33:48PM +0100, Hannes Eder wrote:
> Fix this sparse warning:
>   fs/xfs/xfs_da_btree.c:1550:26: warning: symbol 'xfs_default_nameops' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Looks good to me.

And for future patches please always send them to the mailinglist
(xfs@oss.sgi.com)

