Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZGBURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZGBURo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZGBUQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:16:27 -0400
Received: from kroah.org ([198.145.64.141]:38500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbZGBUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:16:26 -0400
Date: Thu, 2 Jul 2009 13:08:24 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090702200824.GJ10957@kroah.com>
References: <20090629114339.GA25552@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629114339.GA25552@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 01:43:40PM +0200, Pavel Machek wrote:
> 
> This patch adds driver for HTC Dream camera. I guess driver is
> slightly higher quality than usual for staging/ , but it is fairly big
> and I don't feel like doing all the cleanups myself. Also some parts
> can probably be removed, as they did not end up in shipping hardware..
> 
> The driver is actually so big that I'll attach it gzipped, otherwise
> it would not pass maillist limits.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Cc: Brian Swetland <swetland@google.com>

Can you resubmit it with the original author descriptions?  It's not
fair to them to have it shown up as coming from you.

thanks,

greg k-h
