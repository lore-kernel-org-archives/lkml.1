Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbXIXTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbXIXTld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXIXTlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:41:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57012 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760608AbXIXTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:41:22 -0400
Date: Mon, 24 Sep 2007 15:41:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.23-rc7-mm1
In-Reply-To: <46F80D85.9020209@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0709241540420.5920-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Jiri Slaby wrote:

> Hmm, I have usb legacy keyboard switched on because of grub and bios to allow me
>  typing.
> 
> I booted 23-rc7 4 times, and the latest -mm 3 times just now and can't reproduce
> it, I just wonder by what is this conditioned.

Warm boot vs. cold boot, maybe.

Alan Stern

