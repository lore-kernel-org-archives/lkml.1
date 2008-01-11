Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbYAKWkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbYAKWkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbYAKWkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:40:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYAKWkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:40:01 -0500
Date: Fri, 11 Jan 2008 14:39:28 -0800
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
Message-ID: <20080111223928.GB5942@kroah.com>
References: <200801051546.SAA08937@raad.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801051546.SAA08937@raad.intranet>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 06:40:38PM +0300, Al Boldi wrote:
> 
> Reorganize USB Kconfig Menu, and move USB_GADGET out into the Device Driver
> Menu. ?This helps the USB Kconfig Menu to be more logical/usable.
> 
> Patchset against 2.6.23

So what was the final verdict in this patch set?

Can you rsend this against 2.6.24-rc7 with the requested changes (if
any) in it?

thanks,

greg k-h
