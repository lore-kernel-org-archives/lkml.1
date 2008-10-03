Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYJCTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYJCTXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYJCTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:23:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41674 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752087AbYJCTXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:23:01 -0400
Date: Fri, 3 Oct 2008 15:23:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Hansen <dave@sr71.net>
cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <Pine.LNX.4.44L0.0810031429250.6462-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0810031522280.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Alan Stern wrote:

> You should use usbmon (see Documentation/usb/usbmon.txt) to record a 
> trace of everything happening on bus 3.  And to keep things simple, you 
> should unplug all the USB devices except for one of the magical 
> disappearing hubs.

Better still, get two traces: one from each kernel.  Then they can be 
compared.

Alan Stern

