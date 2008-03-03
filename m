Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYCCSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYCCSq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYCCSp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:45:57 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:56144 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035AbYCCSp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:45:56 -0500
Date: Mon, 3 Mar 2008 19:45:52 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit AMD panic
In-Reply-To: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
Message-ID: <alpine.DEB.1.00.0803031942040.5974@sheep.housecafe.de>
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, linux-os (Dick Johnson) wrote:
> We have 64-bit production machines that use the kernel shipped with
> a RedHat distribution, linux-2.6.11-1.1369_FC4smp.

Try asking on the Fedora lists or perhaps it's even in their bugzilla...

> There have been
> no problems until we received recent hardware. With the latest hardware,
> which the vendor claims hasn't changed,

I'm not following: you changed the hardware, but the vendor said, the hard 
did not change?

> the machines panic when either
> a USB mouse or USB keyboard are plugged in.

If you're stuck to this hardware (changed or not): did you try a more 
recent kernel? 2.6.11 is pretty old for lkml....

C.

> The information transmitted in this message is confidential and may
> be privileged.  Any review, retransmission, dissemination, or other

damn, I retransmitted it :)
-- 
BOFH excuse #154:

You can tune a file system, but you can't tune a fish (from most tunefs man pages)
