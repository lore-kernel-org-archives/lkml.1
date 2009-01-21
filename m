Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZAUGyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZAUGyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 01:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZAUGyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 01:54:00 -0500
Received: from kroah.org ([198.145.64.141]:37419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbZAUGyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:54:00 -0500
Date: Tue, 20 Jan 2009 22:48:42 -0800
From: Greg KH <greg@kroah.com>
To: We La <w.landgraf@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc2 rt2860 driver
Message-ID: <20090121064842.GA10184@kroah.com>
References: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 06:30:01AM -0800, We La wrote:
> 1) In the press was published that 2.6.29 would include the rt2860
> WIFI driver.  However, in 2.6.29-rc2 one find nowhere this driver.
> rt2x00 don't work, at least ifconfig ra0 up gives a error message.
> and to compile it from source code, works with 2.6.26.X but not with
> 2.6.29-rc2 (plenty error messages) What's the situation of the rt2860
> driver ??  The only senseful criterion for inclusion of a driver in
> the kernel is not the maturity of the code, but the number of sellings
> of that hardware in the shops, and that driver is necessary for msi
> wind notebooks, so it should be included into the kernel.

It is there, and I have gotten reports of it working properly.  What
problems have you had with it?

thanks,

greg k-h
