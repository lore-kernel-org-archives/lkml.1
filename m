Return-Path: <linux-kernel-owner+w=401wt.eu-S965347AbXBLTr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347AbXBLTr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXBLTr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:47:29 -0500
Received: from mail.kroah.org ([69.55.234.183]:33898 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965347AbXBLTr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:47:28 -0500
Date: Mon, 12 Feb 2007 11:46:39 -0800
From: Greg KH <greg@kroah.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] class device cleanup for fbdev
Message-ID: <20070212194639.GA789@kroah.com>
References: <Pine.LNX.4.64.0702071950110.9071@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071950110.9071@pentafluge.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 07:53:09PM +0000, James Simmons wrote:
> 
> Let me know if this is the right approach. This patch uses the class field 
> in struct device.

Yes, it looks like the correct thing to do.

thanks,

greg k-h
