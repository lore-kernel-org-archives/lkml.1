Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbXLBSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbXLBSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXLBSJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:09:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:54578 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752226AbXLBSJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:09:17 -0500
Date: Sun, 2 Dec 2007 19:09:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       rubini@vision.unipv.it, linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
In-Reply-To: <4752F226.1090003@garzik.org>
Message-ID: <Pine.LNX.4.64.0712021907490.13260@jikos.suse.cz>
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <4752E5AD.40905@rtr.ca>
 <4752F226.1090003@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Jeff Garzik wrote:

> My USB mouse recently started giving me phantom scrolls (movements of 
> the mouse wheel, even I made sure the wheel was in a resting position) 
> in recently kernels.  It happened too infrequently for me to care.

Did this also start in 2.6.24, as in Mark's case?

> USB HID is a fun place to be.

Yes, especially with tons of USB HID devices violating the specs in many 
creative ways :(

Thanks,

-- 
Jiri Kosina
