Return-Path: <linux-kernel-owner+w=401wt.eu-S1030852AbXFHQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030852AbXFHQyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXFHQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:54:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935811AbXFHQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:54:08 -0400
Date: Fri, 8 Jun 2007 12:54:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [usb-storage] 2.6.22-rc4-mm2 - usb-storage
In-Reply-To: <1181320228.7348.290.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0706081252140.3696-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Peter Zijlstra wrote:

> > Okay, this is a separate problem.  To help diagnose it, please turn on 
> > CONFIG_USB_DEBUG and CONFIG_USB_STORAGE_DEBUG and then post the 
> > resulting dmesg log.
> 
> Here goes:
> 
>  http://programming.kicks-ass.net/misc/dmesg

Okay, it's not a separate problem.  You didn't revert the patch I 
mentioned earlier.  It's generating those WARNINGs and causing 
usb-storage to fail.

Alan Stern

