Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbYHAVXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbYHAVXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbYHAVPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:15:44 -0400
Received: from th-mail-b0120.gradwell.net ([193.111.201.44]:46417 "EHLO
	th-mail-b0120.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762024AbYHAVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:15:42 -0400
Date: Fri, 1 Aug 2008 22:15:04 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080801221504.49464f85.alex.buell@munted.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0807301700310.2322-100000@iolanthe.rowland.org>
References: <4890C72D.7040604@shaw.ca>
	<Pine.LNX.4.44L0.0807301700310.2322-100000@iolanthe.rowland.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 17:07:30 -0400 (EDT), I waved a wand and this
message magically appears in front of Alan Stern:

> Index: usb-2.6/drivers/usb/storage/transport.c
[ snip ]

I've just applied this patch to 2.6.25 tonight, and so far, despite my
number of tests, I've yet to experience any more of these failures.

I've done a lot of mkfs and fsck, haven't seen any problems so far.
Fingers crossed that this patch works. 
-- 
http://www.munted.org.uk

Fearsome grindings.
