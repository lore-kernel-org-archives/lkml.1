Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbYHDURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbYHDURp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYHDURf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:17:35 -0400
Received: from sh-spam-4.gradwell.net ([193.84.87.110]:48603 "EHLO
	sh-spam-4.gradwell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYHDURe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:17:34 -0400
Date: Mon, 4 Aug 2008 21:17:06 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080804211706.81d4aafa.alex.buell@munted.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0808041245430.15613-100000@iolanthe.rowland.org>
References: <20080803100706.5e52ce90.alex.buell@munted.org.uk>
	<Pine.LNX.4.44L0.0808041245430.15613-100000@iolanthe.rowland.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 12:48:09 -0400 (EDT), I waved a wand and this
message magically appears in front of Alan Stern:

> > Which patch should I be trying out? 
> 
> That's the right patch.  You should use it with 2.6.27-rc1.

I used that with 2.6.25, works perfectly with PATA devices. I think
maybe the SATA device I have is bad, I have another one I'll try out
later tonight. 
-- 
http://www.munted.org.uk

Fearsome grindings.
