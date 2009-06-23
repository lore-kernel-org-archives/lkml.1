Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZFWPGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZFWPGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbZFWPGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:06:24 -0400
Received: from kroah.org ([198.145.64.141]:55461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760351AbZFWPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:06:23 -0400
Date: Tue, 23 Jun 2009 08:01:14 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090623150114.GA30413@kroah.com>
References: <20090623135529.GA2668@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623135529.GA2668@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:55:29PM +0200, Pavel Machek wrote:
> 
> On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> 
> /proc/bus/usb does not seem to exists.

Newer (as in the past 2 years) versions of lsusb should not need
/proc/bus/usb/

What version of usbutils are you using?

thanks,

greg k-h
