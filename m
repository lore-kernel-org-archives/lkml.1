Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709Ab0BZANY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:13:24 -0500
Received: from kroah.org ([198.145.64.141]:43481 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934695Ab0BZANW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:13:22 -0500
Date: Thu, 25 Feb 2010 15:40:20 -0800
From: Greg KH <greg@kroah.com>
To: Norberto Lopes <nlopes.ml@gmail.com>
Cc: gregkh@suse.de, alan@linux.intel.com, andre.goddard@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: rar: fix errors/warnings related to
 coding style
Message-ID: <20100225234020.GC24155@kroah.com>
References: <1266773827-729-1-git-send-email-nlopes.ml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266773827-729-1-git-send-email-nlopes.ml@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 06:37:07PM +0100, Norberto Lopes wrote:
> 
> Signed-off-by: Norberto Lopes <nlopes.ml@gmail.com>
> ---
>  drivers/staging/rar/rar_driver.c |   82 ++++++++++++++++++-------------------

Unfortunatly, I've taken a patch in my tree that moves this file and
renames it and then cleans up these issues (hopefully).

If you look at the linux-next tree, you will see these changes already,
so I can't accept this patch, sorry.

thanks,

greg k-h
