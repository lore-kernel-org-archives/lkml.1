Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXFGEG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXFGEG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXFGEGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:06:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35619 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXFGEGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:06:19 -0400
Date: Wed, 6 Jun 2007 20:37:20 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       michal.k.k.piotrowski@gmail.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070607033720.GA7740@kroah.com>
References: <20070606221120.upptjxanvowcksss@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606221120.upptjxanvowcksss@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:11:20PM -0500, art@usfltd.com wrote:
>  greg
>  with CONFIG_USB_DEVICE_CLASS=y
>  scanner /dev/scanner-xxxx show up xsane is working now
> 
>  SCANNER PROBLEM SOLVED

Great, thanks for verifying this.  This config option is by default
enabled, so you need to work hard to disable it :)

thanks,

greg k-h
