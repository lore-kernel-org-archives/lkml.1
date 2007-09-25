Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXIYRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXIYRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbXIYRZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:25:42 -0400
Received: from mail.fieldses.org ([66.93.2.214]:48760 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbXIYRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:25:41 -0400
Date: Tue, 25 Sep 2007 13:24:52 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 1/2] Documentation: move mandatory locking
	documentation to filesystems/
Message-ID: <20070925172452.GK30845@fieldses.org>
References: <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org> <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org> <1190132095.6656.12.camel@heimdal.trondhjem.org> <20070918165220.GE18476@fieldses.org> <1190134496.6656.22.camel@heimdal.trondhjem.org> <20070918174016.GF18476@fieldses.org> <20070925165551.GG30845@fieldses.org> <20070925101240.e006ec75.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925101240.e006ec75.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 10:12:40AM -0700, Randy Dunlap wrote:
> One correction below.
...
> > --- a/Documentation/filesystems/00-INDEX
> > +++ b/Documentation/filesystems/00-INDEX
> > @@ -52,6 +52,8 @@ isofs.txt
> >  	- info and mount options for the ISO 9660 (CDROM) filesystem.
> >  jfs.txt
> >  	- info and mount options for the JFS filesystem.
> > +mandatory
> 
>    mandatory-locking.txt

Thanks, fixed.

--b.
