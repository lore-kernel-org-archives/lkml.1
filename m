Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbXBPPN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbXBPPN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964986AbXBPPN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:13:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53488 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964982AbXBPPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:13:27 -0500
Date: Fri, 16 Feb 2007 10:13:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] 2.6.20 USB issue(?) [disabled by hub(EMI?)]
In-Reply-To: <Pine.LNX.4.64.0702160928550.13505@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0702161012370.3374-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Justin Piszcz wrote:

> This happens under heavy I/O + network traffic, it happened again, this 
> time under 2.6.20-- is this normal/or would it be considered a bug? 

It would be considered a bug in your device, not a bug in the kernel.

Alan Stern

