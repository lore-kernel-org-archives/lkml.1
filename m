Return-Path: <linux-kernel-owner+w=401wt.eu-S965560AbXBSXuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965560AbXBSXuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965559AbXBSXuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:50:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:43424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965561AbXBSXuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:50:20 -0500
Date: Mon, 19 Feb 2007 15:48:46 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.41
Message-ID: <20070219234846.GA5201@kroah.com>
References: <20070218011406.GT13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218011406.GT13958@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 02:14:07AM +0100, Adrian Bunk wrote:
> Herbert Xu (1):
>       [NETFILTER]: Clear GSO bits for TCP reset packet

This patch causes the file it patched to not build at all.  Are you sure
it was correct to add this?

thanks,

greg k-h
