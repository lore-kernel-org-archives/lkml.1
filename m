Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZHQEqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZHQEqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 00:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHQEqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 00:46:12 -0400
Received: from kroah.org ([198.145.64.141]:59035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZHQEqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 00:46:11 -0400
Date: Sun, 16 Aug 2009 21:44:50 -0700
From: Greg KH <greg@kroah.com>
To: Christian Roche <christian.roche.fr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops: sysfs: duplicate filename 'usbdev3.3_ep81' can not be
 created
Message-ID: <20090817044450.GB20884@kroah.com>
References: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 02:56:29PM +0100, Christian Roche wrote:
> Hi there,
> 
> I'm encountering a kernel oops when trying to use a USB 3G modem. The
> modem is an LG LDU-1900D USB key used in Morocco to access Wana's 3G
> network. The modem works fine in Vista but comes with no Linux
> drivers. I've seen one similar message in the list archive, but it
> seems to be related to another, already corrected bug
> (http://www.gossamer-threads.com/lists/linux/kernel/981459#981459).
> 
> Does anyone here have an idea ? Thanks to kindly keep me cc'ed, I'm
> not subscribed to the list (a tad too technical for me :-)
> 
> My system: Linux jimi 2.6.29.6-217.2.3.fc11.i586 #1 SMP Wed Jul 29
> 15:46:46 EDT 2009 i686 i686 i386 GNU/Linux

Please try a 2.6.30 kernel release, this problem has been fixed in
there.

thanks,

greg k-h
