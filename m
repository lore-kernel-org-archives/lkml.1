Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYGXGbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYGXGbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYGXGbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:31:34 -0400
Received: from th-mail-b0114.gradwell.net ([193.111.201.38]:40623 "EHLO
	th-mail-b0114.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYGXGbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:31:33 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 02:31:32 EDT
Date: Thu, 24 Jul 2008 07:15:17 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tomas Styblo <tripie@cpan.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080724071517.e1bcdf92.alex.buell@munted.org.uk>
In-Reply-To: <48859E2C.4070805@shaw.ca>
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no>
	<4884E585.2050104@shaw.ca>
	<20080722051110.GA8303@notebook.homenet.local>
	<488570A5.8000602@shaw.ca>
	<20080722061147.GB8303@notebook.homenet.local>
	<48859E2C.4070805@shaw.ca>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 02:45:32 -0600, I waved a wand and this message
magically appears in front of Robert Hancock:

> I suppose it wouldn't hurt to let JMicron know about this. I doubt
> they could do anything for existing chipsets, but it might help them
> avoid this bug in future designs.

I, too, have the same chipet. I have observed the same corruption bug
with SATA disks only. PATA disks works perfectly. 

When I have more time and a spare SATA disk, I will try and reproduce
the same problem and post results on here, in the hope someone will
come up with a fix for it. 

It is very annoying not being able to use cheaper SATA disks for
backing up my boxes instead of slightly more expensive PATA disks. 
-- 
http://www.munted.org.uk

Fearsome grindings.
