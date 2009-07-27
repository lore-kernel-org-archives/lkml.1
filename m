Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959AbZG0QPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbZG0QPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZG0QPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:15:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:56107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZG0QPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:15:37 -0400
Date: Mon, 27 Jul 2009 09:10:33 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
Message-ID: <20090727161031.GA15328@suse.de>
References: <20090727090642.0e495919.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727090642.0e495919.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:06:42AM -0700, Randy Dunlap wrote:
> From:	Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
> Subject: [PATCH] documentation: make it clear that sysfs is optional
> 
> The original text suggested that sysfs is mandatory and always
> compiled in the kernel.

But it should be :)

Seriously, who turns sysfs off these days, does anyone?  If so, why?

thanks,

greg k-h
