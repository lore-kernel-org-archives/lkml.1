Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXFARPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXFARPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760990AbXFARPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:15:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53769 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348AbXFARPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:15:08 -0400
Date: Fri, 1 Jun 2007 06:35:22 -0700
From: Greg KH <greg@kroah.com>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB adutux device number
Message-ID: <20070601133522.GA7781@kroah.com>
References: <35fbaa3e0705140910s19feac4bnd71a80f25dc4753c@mail.gmail.com> <35fbaa3e0705150505i5f85f1a0rade73340cd60f690@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fbaa3e0705150505i5f85f1a0rade73340cd60f690@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 03:05:41PM +0300, Vitaliy Ivanov wrote:
>  Did any of USB fellows has a chance to look at this issue?
> 
>  It can be critical to customers as this 67 minor number is listed in
>  the driver code only and not all of them going through the code.

Yeah, someone reverted all of the USB minor numbers in this file, I'll
work to fix it up again...

thanks,

greg k-h
