Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbXITADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbXITADT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXITADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:03:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48748 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbXITADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:03:11 -0400
Date: Wed, 19 Sep 2007 17:03:36 -0700
From: Greg KH <greg@kroah.com>
To: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: Serial USB-driver for Winchiphead CH340/41 chip
Message-ID: <20070920000336.GA17357@kroah.com>
References: <200709141438.55147.Werner.Cornelius@cornelius-consult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141438.55147.Werner.Cornelius@cornelius-consult.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 02:38:55PM +0200, Werner Cornelius wrote:
> Hello,
> 
> I know that there has been a patch for the Winchiphead CH340/41 USB to serial 
> converter chips on the net, but they have been implemented with only a basic 
> feature and limited baudrates due to the lack of any datasheets.
> 
> I picked these patches up and added all common baudrates as well as the 
> complete modem control and status handling to be able of using this adapter 
> in nearly all applications.

Care to just send me a patch against the -mm tree, for these new
features?  The driver, with the proper attribution from the original
author, is already in that tree and will be going into the 2.6.24
release.

thanks,

greg k-h
