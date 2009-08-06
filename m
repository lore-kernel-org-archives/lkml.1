Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZHFPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZHFPWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbZHFPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:22:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:53462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbZHFPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:22:39 -0400
Date: Thu, 6 Aug 2009 08:21:35 -0700
From: Greg KH <gregkh@suse.de>
To: Dhaval Vasa <dhaval.vasa@einfochips.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: add product_id for Marvell OpenRD Base,
 Client
Message-ID: <20090806152135.GA26445@suse.de>
References: <1249569566-824-1-git-send-email-dhaval.vasa@einfochips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249569566-824-1-git-send-email-dhaval.vasa@einfochips.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:09:26PM +0530, Dhaval Vasa wrote:
> reference:
> http://www.open-rd.org
> 
> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
> ---
>  drivers/usb/serial/ftdi_sio.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

You also need to change ftdi_sio.c in order to add support for this
device id.  Care to redo the patch?

thanks,

greg k-h
