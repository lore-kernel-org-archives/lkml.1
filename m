Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYEOOlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYEOOlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYEOOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:41:40 -0400
Received: from eazy.amigager.de ([213.239.192.238]:56036 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYEOOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:41:39 -0400
Date: Thu, 15 May 2008 15:40:46 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515134046.GA9529@dose.home.local>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
	linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080514221519.GA6575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514221519.GA6575@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 15:15:19 -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This driver was originally written by James McKenzie but forward ported
> and cleaned up by me to get it to work with modern kernel versions.
> 
> Tested on my mac mini and it actually works!

Did you test suspend to RAM? Last time I used the original driver, I
had to reload it after resume, otherwise LIRC didn't receive events
anymore.

Regards,
Tino
