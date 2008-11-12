Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbYKLFGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbYKLFGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYKLFGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:06:13 -0500
Received: from kroah.org ([198.145.64.141]:49632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbYKLFGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:06:12 -0500
Date: Tue, 11 Nov 2008 21:02:30 -0800
From: Greg KH <greg@kroah.com>
To: Leslie Watter <leslie.watter@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Adding YISO u893 usb modem vendor and product IDs
Message-ID: <20081112050230.GA19844@kroah.com>
References: <8a966de80811111751x67feb700l774cbba30b21c81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a966de80811111751x67feb700l774cbba30b21c81@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 11:51:10PM -0200, Leslie Watter wrote:
> Hi,
> 
> I would be glad if someone could take a look/apply the following patch.
> 
> This patch (against 2.6.27) adds YISO u893 usb modem vendor and
> product ID to option.c.
> 
> I had a better experience using this modification and the same system.

So it works for you with this device id added?

Care to resend this with a "Signed-off-by"?

thanks,

greg k-h
