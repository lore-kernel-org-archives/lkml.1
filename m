Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYJEUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYJEUbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 16:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYJEUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 16:31:10 -0400
Received: from www.sr71.net ([198.145.64.142]:51733 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYJEUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:31:09 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810051509110.32325-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0810051509110.32325-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 13:31:07 -0700
Message-Id: <1223238667.10597.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-05 at 15:16 -0400, Alan Stern wrote:
> That file is the usbmon log from back on Friday.  I need to see the
> usbmon log you get with the timing fix installed.  Was that not clear?  
> Without the log, I can't tell why the disconnects continue to occur
> even though the timing fix should have eliminated them.

It looks like I didn't properly apply the timing fix when I said I did
last time.  With Thomas/Hugh's fix applied, I don't see the disconnects
any more.  I'll keep an eye out and let everyone know if they reappear.

Thanks for all the excellent debugging, everyone!

-- Dave

