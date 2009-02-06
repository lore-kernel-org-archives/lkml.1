Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZBFTLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZBFTLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZBFTLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:11:19 -0500
Received: from kroah.org ([198.145.64.141]:51473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197AbZBFTLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:11:17 -0500
Date: Fri, 6 Feb 2009 10:52:39 -0800
From: Greg KH <greg@kroah.com>
To: Dirk DeSchepper <ddeschepper@nvtl.com>
Cc: smurf@smurf.noris.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be
	supported through option module
Message-ID: <20090206185239.GC8517@kroah.com>
References: <12047829252365@kroah.org> <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D1E0@Vectra.nvtl.local> <20090206003352.GA22530@kroah.com> <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D2A3@Vectra.nvtl.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D2A3@Vectra.nvtl.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 11:29:06AM -0000, Dirk DeSchepper wrote:
> From: Dirk De Schepper <ddeschepper@nvtl.com>
> 
> Patch for option.c, based on kernel v2.6.28.3
> - New Novatel and Dell mobile broadband modem products added
> - Dell pid variables used in stead of numerical PIDs for known products 
> 
> Signed-off-by: Dirk De Schepper <ddeschepper@nvtl.com>

Hm, your patch is line-wrapped and can't be applied :(

Care to try it again?  Perhaps as an attachment if your email client
can't do it any other way?

thanks,

greg k-h
