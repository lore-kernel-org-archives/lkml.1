Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbXI1Sf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbXI1Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXI1SfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:35:14 -0400
Received: from verein.lst.de ([213.95.11.210]:47840 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbXI1SfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:35:12 -0400
Date: Fri, 28 Sep 2007 20:35:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 04/10] Move struct path into its own header
Message-ID: <20070928183509.GD14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141227.965678524@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141227.965678524@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:04PM +0200, jblunck@suse.de wrote:
> Move the definition of struct path into its own header file for further
> patches.

Ok.

