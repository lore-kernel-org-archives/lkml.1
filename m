Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYIDWQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYIDWQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYIDWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:16:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:60038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYIDWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:16:33 -0400
Date: Thu, 4 Sep 2008 15:15:55 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080904221555.GA22738@kroah.com>
References: <20080903191023.GF2772@parisc-linux.org> <Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org> <20080904214802.GO2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904214802.GO2772@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 03:48:02PM -0600, Matthew Wilcox wrote:
> 
> I don't have a USB hub, so I can't tell you what happens if the exported
> device is plugged into one.

I strongly suggest, if you are going to be touching USB code, that you
spend the $10 and get yourself a hub, I'm sure Intel might even allow
you to expense it.

If not, I'll take up a collection for you at the Plumbers conference :)

thanks,

greg k-h
