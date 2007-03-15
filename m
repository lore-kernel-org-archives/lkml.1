Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXCOVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXCOVyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCOVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:54:49 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46618 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXCOVys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:54:48 -0400
Date: Thu, 15 Mar 2007 22:54:33 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [linux-usb-devel] USB Keyboard
In-Reply-To: <Pine.LNX.4.61.0703151745360.5799@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0703152252560.12394@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0703151506010.2482-100000@iolanthe.rowland.org>
 <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com>
 <Pine.LNX.4.64.0703152236390.12394@twin.jikos.cz>
 <Pine.LNX.4.61.0703151745360.5799@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:

> Yes! I will try it in the morning. It's now past quitting time and, 
> following this thread, you will note that the ohci module needed to be 
> loaded for this AMD unit so the keyboard now works! I will remove the 

Oh I see, looks like I have been deleted from CC in the middle of the 
thread, so sorry for superfluous reply. However, the fact about usbkbd 
still applies - it is almost certain that you don't want to use it, and 
you'd better keep it unloaded.

-- 
Jiri Kosina
