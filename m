Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZGVWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZGVWpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZGVWpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:45:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44413 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752262AbZGVWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:45:07 -0400
Date: Wed, 22 Jul 2009 18:45:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090722233544.34b91378@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907221843560.21938-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Alan Cox wrote:

> At the moment I have two main goals
> 
> - Get to the point where every serial port in the system contains a tty
>   port
> - Remove the 10 million alternative mis-implementations of half the tty
>   code found in each driver or in "glue" that does what the tty layer
>   should be doing (half of usb-serial, most of the uart layer)
> 
> All without being able to just break it for six months and drop support
> for most of the hardware.

Okay.  If there's anything more I can do to help with updating
usb-serial, let me know.

Alan Stern

