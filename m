Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0BXArO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:47:14 -0500
Received: from kroah.org ([198.145.64.141]:59859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0BXAq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:46:57 -0500
Date: Tue, 23 Feb 2010 16:42:21 -0800
From: Greg KH <greg@kroah.com>
To: Richard Colquhoun <arfab@lavabit.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix spacing errors and commenting
 format in r8180_93cx6.c
Message-ID: <20100224004221.GA27872@kroah.com>
References: <4B7C0406.9040400@lavabit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7C0406.9040400@lavabit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	ret=0;
> -        //enable EPROM programming
> +	ret = 0;
> +	#enable EPROM programming

This is not valid C.  Please build the code before sending in patches.

Also, you might want to brush up on your C programming skills :)

thanks,

greg k-h
