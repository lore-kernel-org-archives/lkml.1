Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZCDFUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZCDFUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 00:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZCDFUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 00:20:03 -0500
Received: from kroah.org ([198.145.64.141]:42631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750739AbZCDFUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 00:20:03 -0500
Date: Tue, 3 Mar 2009 20:35:14 -0800
From: Greg KH <greg@kroah.com>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]some cleanup on drivers/base/sys.c
Message-ID: <20090304043514.GA31892@kroah.com>
References: <20090303103602.GA9658@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303103602.GA9658@helight>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 06:36:02PM +0800, Zhenwen Xu wrote:
> 
> do some cleanup on drivers/base/sys.c
> 
> >From ca17f201964ccd9f305808617560fd1945bf4046 Mon Sep 17 00:00:00 2001
> From: Zhenwen Xu <helight.xu@gmail.com>
> Date: Tue, 3 Mar 2009 18:23:29 +0800
> Subject: [PATCH] some cleanup on drivers/base/sys.c

I have no objection to this, and I'll queue it up, but I'm curious, what
made you want to do this patch?

Care to do other work in the driver core?  :)

thanks,

greg k-h
