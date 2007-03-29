Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXC2QD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXC2QD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030326AbXC2QD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:03:27 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2895 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXC2QD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:03:27 -0400
Message-ID: <460BE34D.7050603@rtr.ca>
Date: Thu, 29 Mar 2007 12:03:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, Andrew Morton <akpm@osdl.org>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
References: <Pine.LNX.4.44L0.0703291155000.3108-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703291155000.3108-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Mar 2007, Mark Lord wrote:
>
>> Mmm.. this sounds really bad -- I wonder what happens if the rootfs is on USB ?
> 
> The system crashes as soon as it resumes.  As you might expect.
> 
>> With older kernels, things just "worked" this way.  Has it now been broken ??
> 
> No; it has never worked.  Your memory of how older kernels behaved is wrong.

Ah. Perhaps my Kubuntu system was using a FreeBSD kernel under the hood back then.
It really did work for me, back about 2 years ago when last attempted.
But then suspend/resume (RAM) has always worked here on every notebook
I've ever used -- apparently not the norm for others.  I just expect more.

> P.S.: Help is on the way.  I will soon submit a patch to help improve the situation.

That would be very good to see.

-ml
