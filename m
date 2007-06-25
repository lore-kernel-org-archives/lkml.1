Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbXFYV4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbXFYV4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbXFYV4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:56:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50626 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbXFYV4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:56:31 -0400
Date: Mon, 25 Jun 2007 14:24:48 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs_buffer: use mutex
Message-ID: <20070625212448.GA13415@kroah.com>
References: <1182503684.21939.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182503684.21939.76.camel@johannes.berg>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 11:14:44AM +0200, Johannes Berg wrote:
> I don't see any reason why this is a semaphore, convert.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

There has been a _lot_ of work in this area and this patch doesn't apply
at all to my tree.  Can you respin it agains the next -mm release that
comes out?

thanks,

greg k-h
