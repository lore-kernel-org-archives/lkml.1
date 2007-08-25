Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbXHYEYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbXHYEYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXHYEYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:24:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:38112 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXHYEYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:24:04 -0400
Date: Fri, 24 Aug 2007 18:38:08 -0700
From: Greg KH <greg@kroah.com>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: coldplug zd1211rw wireless driver results in firefox segfault
Message-ID: <20070825013808.GA24439@kroah.com>
References: <1187986902.24891.12.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187986902.24891.12.camel@albrecht.rdi1.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 04:21:42PM -0400, Paul Albrecht wrote:
> Hi,
> 
> I'm trying to use a hawking hwu54g with the zd1211rw driver in the
> 2.6.20 linux kernel. It works ok when I hotplug the device, but causes
> firefox to segfault when I coldplug the device.
> 
> As I get the segfault whether or not I bring the device up, I'm
> wondering if there's a problem with the usb subsystem initialization.
> 
> Any ideas? Please cc me because I don't usually subscribe to the lkml.

Can you try a newer kernel?  That driver has gotten a lot of work in the
past 6 months.

thanks,

greg k-h
