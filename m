Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYFTJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYFTJyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYFTJyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:54:03 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:34785 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYFTJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:53:24 -0400
Date: Fri, 20 Jun 2008 11:53:11 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org,
       mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before
	mounting root
Message-ID: <20080620095311.GK15159@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org> <200806191613.25552.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806191613.25552.david-b@pacbell.net>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:13:25PM -0700, David Brownell wrote:

> Why give up, ever? 

It would be quite useful to time out and reboot using the previous
kernel ("lilo -R") when one wants to figure out remotely why the new
kernel does not boot.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
