Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZBHSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZBHSIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZBHSIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:08:10 -0500
Received: from kroah.org ([198.145.64.141]:38723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbZBHSII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:08:08 -0500
Date: Sun, 8 Feb 2009 10:05:48 -0800
From: Greg KH <greg@kroah.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>
Subject: Re: WARNING: at drivers/usb/storage/transport.c:584
	last_sector_hacks+0x12a/0x190 [usb_storage]()
Message-ID: <20090208180548.GB9376@kroah.com>
References: <8db1092f0902080940i390efc72i18046210931606a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0902080940i390efc72i18046210931606a9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 06:40:16PM +0100, Maciej Rutecki wrote:
> Pendrive 1GB, in 2.6.28 works without any problems (also in XP and Vista)
> 
> 2.6.29-rc3:

Thanks, this warning is about to go away, it was used to evaluate how
many pieces of broken hardware really are out there in the wild (turns
out a lot...)

thanks,

greg k-h
