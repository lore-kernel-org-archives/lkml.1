Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZDVGJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZDVGJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZDVGIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:08:55 -0400
Received: from kroah.org ([198.145.64.141]:37199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbZDVGIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:08:54 -0400
Date: Tue, 21 Apr 2009 22:53:27 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Message-ID: <20090422055327.GF9009@kroah.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:04:17PM -0400, H Hartley Sweeten wrote:
> Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
> 
> 	warning: symbol 'temp' shadows an earlier one
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

I'm not seeing this sparse warning either.

And you didn't fix the two sparse warnings I am seeing in this file, so
I'm going to think this patch doesn't really do anything :(

thanks,

greg k-h
