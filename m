Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZGBUQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZGBUQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZGBUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:16:21 -0400
Received: from kroah.org ([198.145.64.141]:38483 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZGBUQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:16:21 -0400
Date: Thu, 2 Jul 2009 12:33:26 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192su: add TODO
Message-ID: <20090702193326.GD10957@kroah.com>
References: <200906281740.50426.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906281740.50426.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 05:40:50PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

With all of your rtl8192su patches, I'm getting the following build
error:
	ERROR: "ieee80211_xmit" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!

any ideas?

thanks,

greg k-h
