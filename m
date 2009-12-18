Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbZLRTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbZLRTfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZLRTfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:35:21 -0500
Received: from kroah.org ([198.145.64.141]:47501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZLRTfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:35:21 -0500
Date: Fri, 18 Dec 2009 10:20:16 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/rtl8187x: Use %pM for mac address
 output
Message-ID: <20091218182016.GC2909@kroah.com>
References: <1260128092.11126.119.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260128092.11126.119.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 11:34:52AM -0800, Joe Perches wrote:
> Uncompiled.  Doesn't currently build anyway.

Builds here for me :)

Looks good, thanks.

greg k-h
