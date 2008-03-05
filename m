Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbYCEXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbYCEXGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765453AbYCEW7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:59:50 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:41051 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbYCEW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:59:47 -0500
Date: Wed, 5 Mar 2008 23:59:36 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Brownell <david-b@pacbell.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <200803042025.30613.david-b@pacbell.net>
Message-ID: <alpine.DEB.1.00.0803052357400.8658@sheep.housecafe.de>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041630.11832.david-b@pacbell.net> <alpine.DEB.1.00.0803050215140.7069@sheep.housecafe.de> <200803042025.30613.david-b@pacbell.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:
> Nah.  See the patch I just attached to
> 	http://bugzilla.kernel.org/show_bug.cgi?id=10078

Thanks, I'm compiling (applied to -rc4 with some fuzz, hope that's ok) 
now and will test tomorrow.

C.
-- 
BOFH excuse #269:

Melting hard drives
