Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbXJIJRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbXJIJRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 05:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXJIJQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 05:16:55 -0400
Received: from verein.lst.de ([213.95.11.210]:42103 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXJIJQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 05:16:55 -0400
Date: Tue, 9 Oct 2007 11:16:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 00/10] Use struct path in struct nameidata
Message-ID: <20071009091651.GA20394@lst.de>
References: <20070927141200.820970144@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141200.820970144@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any reasons this didn't go into -mm?  It's all straight-forward cleanup
and it would be a pity not to see it in 2.6.24

On Thu, Sep 27, 2007 at 04:12:00PM +0200, jblunck@suse.de wrote:
> This is a respin of the patch series Andreas posted last month. It leaves out
> the restructuring of the intent which will be done at a later point in time.
> 
> There are three preparing patches that remove unneeded code IMHO. I haven't
> got feedback from Takashi since he is on holiday. Please, can somebody else
> acknowledge the changes?
> 
> Comments?
> Jan
> -- 
---end quoted text---
