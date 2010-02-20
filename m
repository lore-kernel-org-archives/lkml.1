Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0BTV0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:26:20 -0500
Received: from kroah.org ([198.145.64.141]:48966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab0BTV0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:26:19 -0500
Date: Sat, 20 Feb 2010 13:26:45 -0800
From: Greg KH <greg@kroah.com>
To: chris.nicholson@cnick.org.uk
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: fix brace coding style issue in Channel.c
Message-ID: <20100220212645.GA22839@kroah.com>
References: <1266698183-26781-1-git-send-email-chris.nicholson@cnick.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266698183-26781-1-git-send-email-chris.nicholson@cnick.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 08:36:23PM +0000, chris.nicholson@cnick.org.uk wrote:
> From: Chris Nicholson <chris.nicholson@cnick.org.uk>
> 
> This is a patch to the Channel.c file that fixes up a brace
> warning found by checkpatch.pl
> 
> Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
> ---
>  drivers/staging/hv/Channel.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Looks good, I'll queue it up next week.

thanks,

greg k-h
