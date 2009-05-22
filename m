Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZEVSTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZEVSTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZEVST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:19:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58751 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753191AbZEVST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:19:27 -0400
Date: Fri, 22 May 2009 14:19:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pantelis Koukousoulas <pktoss@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <1295ed070905220923u32a42c42pd9615e8f9b665815@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905221418110.3006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Pantelis Koukousoulas wrote:

> Note though, I assume that there is / will be a way to reliably
> predict the port
> number (at least roughly) given a physical port location. E.g., if I plugged
> a device to my front left usb connector and it got port number X, it should
> be possible to predict what the port number will be if I reconnect the same
> device to the same connector. (This doesn't have to hold across reboots).

If you don't reboot between connects, the port numbers and hub 
identifiers will not change.

Alan Stern

