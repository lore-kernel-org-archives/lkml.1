Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbXIMXsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbXIMXsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405AbXIMXpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41162 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbXIMXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:07 -0400
Date: Thu, 13 Sep 2007 16:23:33 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070913232333.GB32307@kroah.com>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org> <20070910124358.GB21089@ftp.linux.org.uk> <20070910102556.de35e825.akpm@linux-foundation.org> <20070910184454.6c2a8ab9@the-village.bc.nu> <20070910105410.25e1d54c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910105410.25e1d54c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 10:54:10AM -0700, Andrew Morton wrote:
> 
> I once made the mistake of putting a "please tell andrewm@uow.edu.au" printk
> in 3c59x.c.  My inbox nearly died.  Then there's that damned "PCI bus hidden
> behind transparent bus" printk which I've actually removed from -mm because
> so many people keep reporting it and we don't do anything about it.

This has now been fixed in the main tree too.

thanks,

greg k-h
