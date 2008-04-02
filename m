Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYDBTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYDBTVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbYDBTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:21:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756406AbYDBTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:20:59 -0400
Date: Wed, 2 Apr 2008 15:20:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: David Brownell <david-b@pacbell.net>, <pavel@suse.cz>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jikos@suse.cz>, <gregkh@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
In-Reply-To: <47F3CB91.1@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0804021519550.11421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Mark Lord wrote:

> Either patch is stable here, and have survived reboots and suspend/resumes,
> with and without the 2.2Kohm resistor to drain residual USB voltage.

Great!  Thanks for testing.

> Which one should Andrew/Linus take?

It's up to David, of course.  My preference is for the patch I 
proposed, naturally enough.  It fixes the cause rather than the 
symptom.

Alan Stern

