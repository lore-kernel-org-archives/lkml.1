Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYHIFGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYHIFGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 01:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYHIFGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 01:06:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:60772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYHIFGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 01:06:47 -0400
Date: Fri, 8 Aug 2008 21:53:53 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add vendor/product id of ZTE MF628 to option
Message-ID: <20080809045353.GA342@kroah.com>
References: <20080809044530.193a077a@ors.home> <20080809044926.46c494d9@ors.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809044926.46c494d9@ors.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 04:49:26AM +0200, Oliver Martin wrote:
> This adds the vendor and product id (19d2:0015) of the ZTE MF628 HSDPA
> modem to the option driver. It still needs a mode switch command issued
> beforehand, this is currently handled by a userspace tool.
> 
> Signed-off-by: Oliver Martin <oliver.martin@student.tuwien.ac.at>

In the future, please CC: any usb patch to the linux-usb mailing list,
and the USB maintainer to make sure it gets picked up properly.
Otherwise, odds are I'll miss it :(

thanks,

greg k-h
