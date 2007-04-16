Return-Path: <linux-kernel-owner+w=401wt.eu-S1030928AbXDPT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030928AbXDPT4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030926AbXDPT4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:56:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56870 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030928AbXDPT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:56:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4623D4DA.60600@s5r6.in-berlin.de>
Date: Mon, 16 Apr 2007 21:56:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
References: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>	 <46238936.3060501@shaw.ca> <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
In-Reply-To: <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On 4/16/07, Robert Hancock <hancockr@shaw.ca> wrote:
>> Chipset limitation. It uses up most of the MMIO region above 3GB
>> preventing RAM from being mapped there, and doesn't support remapping
>> the covered RAM to above 4GB. Nothing the kernel can do about it.
> 
> Well, I guess I learned the hard way. So it's better not to buy 4GB
> ... it turns out to be the same as buying one with just 3GB RAM.

Except for minimal performance differences if the 3GB configuration
doesn't support dual-channel mode.  (Not worth the price difference to 4GB.)
-- 
Stefan Richter
-=====-=-=== -=-- =----
http://arcgraph.de/sr/
