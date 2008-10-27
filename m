Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYJ0Qhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYJ0Qhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYJ0Qh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:37:27 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44202 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYJ0Qh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:37:26 -0400
Message-ID: <4905EE45.4080001@lwfinger.net>
Date: Mon, 27 Oct 2008 09:37:25 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB device'
 messages
References: <Pine.LNX.4.44L0.0810251058050.3569-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810251058050.3569-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> 
> Just build your test kernel with USB debugging enabled, and when you 
> get that spamming, post the complete dmesg log.

Once I added ehci_hcd to my initrd, which ensured that it was loaded first, the
error messages seem to have disappeared. If they return, I'll open a new thread.

Thanks for the help,

Larry

