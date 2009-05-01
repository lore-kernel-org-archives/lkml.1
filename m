Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZEAVhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZEAVhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZEAVg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:36:58 -0400
Received: from kroah.org ([198.145.64.141]:42826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZEAVg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:36:57 -0400
Date: Fri, 1 May 2009 14:07:56 -0700
From: Greg KH <greg@kroah.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29-rc8] drivers/staging/otus/ioctl.c: Fix Coding
	Style
Message-ID: <20090501210756.GA27299@kroah.com>
References: <alpine.DEB.2.00.0904261019200.9155@Sentinel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904261019200.9155@Sentinel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 10:20:54AM +0200, Dragoslav Zaric wrote:
> Signed-off-by: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>

This patch doesn't apply at all for some reason :(

Also:
> 
> --- drivers/staging/otus/ioctl.c	2009-03-16 23:10:02.000000000 +0100
> +++ drivers/staging/otus/ioctl_new.c	2009-03-25 00:19:47.000000000 +0100

Please create your patches so they can be applied with a '-p1' option.

Run them through scripts/checkpatch.pl before sending them off, it will
catch things like this.

thanks,

greg k-h
