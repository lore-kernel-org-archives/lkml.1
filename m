Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYH2OeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYH2OeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbYH2OeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:34:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbYH2OeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:34:15 -0400
Date: Fri, 29 Aug 2008 07:32:05 -0700
From: Greg KH <greg@kroah.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/03] USB: USB/IP: add common functions needed
Message-ID: <20080829143205.GA18136@kroah.com>
References: <20080828225248.758800945@mini.kroah.org> <20080828230031.GB15014@kroah.com> <g989sb$t5n$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g989sb$t5n$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 01:52:48PM +0600, Alexander E. Patrakov wrote:
> Greg KH wrote:
> 
> > From: Takahiro Hirofuchi
> > +       This enables pushing USB packets over IP to allow remote
> > +       machines access to USB devices directly.  For more details,
> > +       and links to the userspace utility programs to let this work
> > +       properly, see http://usbip.naist.jp/
> 
> Connection to this site times out here and now. Did your LKML post cause a
> DoS attack?

The site has moved to usbip.sf.net, as stated in the 00/03 patch.  That
should be working.

thanks,

greg k-h
