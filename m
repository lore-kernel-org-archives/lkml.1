Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbYH2Fot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbYH2Fot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 01:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYH2Foj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 01:44:39 -0400
Received: from 1wt.eu ([62.212.114.60]:3071 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYH2Foi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 01:44:38 -0400
Date: Fri, 29 Aug 2008 07:43:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
Subject: Re: [patch 03/03] USB: USB/IP: add host driver
Message-ID: <20080829054343.GC19337@1wt.eu>
References: <20080828225248.758800945@mini.kroah.org> <20080828230038.GD15014@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828230038.GD15014@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 04:00:38PM -0700, greg@kroah.com wrote:
> From: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> 
> This adds the USB IP client driver

Seems this changelog is wrong because the help says it's the host :

> +config USB_IP_HOST
> +	tristate "USB IP host driver"
> +	depends on USB_IP_COMMON
> +	---help---
> +	 This enables the USB IP device driver which will run on the
> +	 host machine.
> +
> +	 To compile this driver as a module, choose M here: the
> +	 module will be called usbip.

Very cool stuff anyway !

regards,
Willy

