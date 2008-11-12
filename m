Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYKLRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYKLRHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYKLRH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:07:27 -0500
Received: from kroah.org ([198.145.64.141]:44811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbYKLRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:07:26 -0500
Date: Wed, 12 Nov 2008 09:03:03 -0800
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch 00/49] 2.6.27.5 stable review
Message-ID: <20081112170303.GB26878@kroah.com>
References: <20081112002215.GA10989@kroah.com> <200811121508.55791.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121508.55791.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 03:08:55PM +0100, Frans Pop wrote:
> Would it be possible to include the commit below now that it's been 
> accepted into mainline?
> 
> Thanks,
> FJP
> 
> commit bf1b36445dc868cbbde194aa1dd87e38fe24cf16
> Author: Jonathan McDowell <noodles@earth.li>
> Date:   Sat Sep 13 17:08:31 2008 +0100
> 
>     kbuild: Fixup deb-pkg target to generate separate firmware deb

I will queue it up for the next -stable release after this one.

thanks,

greg k-h
