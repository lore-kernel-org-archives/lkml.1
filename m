Return-Path: <linux-kernel-owner+w=401wt.eu-S933943AbZJIQ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbZJIQ30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbZJIQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:29:24 -0400
Received: from kroah.org ([198.145.64.141]:33641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862AbZJIQ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:29:23 -0400
Date: Fri, 9 Oct 2009 09:22:10 -0700
From: Greg KH <greg@kroah.com>
To: Steve Friedl <steve@unixwiz.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: hv: Fixed typo in Hyper-V struct name:
 VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER
Message-ID: <20091009162210.GB2766@kroah.com>
References: <20090922054928.GA6077@dcent.unixwiz.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922054928.GA6077@dcent.unixwiz.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:49:28PM -0700, Steve Friedl wrote:
> [ This may be a dup, didn't see the previous try ]
> 
> It seems that the VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER typedef/struct was
> misspelled (...MULIT.. -> ...MULTI...) so I felt compelled to fix it. This
> was the only change in this patch.
> 
> ~~~ Steve
> 
> Signed-off-by: Steve Friedl <steve@unixwiz.net>

The file, drivers/staging/hv/TODO say who to cc: for when you want to
submit patches for the drivers/staging/hv/* files.

So, do you still want these patches applied?  Do they apply to
2.6.32-rc3?

If not, please resend.

Heck, please resend them all again anyway, with the correct cc: in place
so that all involved can review them properly.

thanks,

greg k-h
