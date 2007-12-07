Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXLGLxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXLGLxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGLw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:52:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:53866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751455AbXLGLw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:52:59 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+NbwozjFmNi2albdfG7wqLbs3u4bEC5X4bGH161/
	UYWzfrAXNBx6a1
Date: Fri, 7 Dec 2007 12:53:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Markus <M4rkusXXL@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
In-Reply-To: <200712071240.27838.M4rkusXXL@web.de>
Message-ID: <Pine.LNX.4.64.0712071252040.29411@axis700.grange>
References: <200712061906.42070.M4rkusXXL@web.de> <200712061927.35976.M4rkusXXL@web.de>
 <Pine.LNX.4.64.0712062207320.25344@axis700.grange> <200712071240.27838.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Markus wrote:

> Hi again!
> 
> The memtest ran 14 passes (~10h) without an error.
> 
> I now have a 2.6.24-rc4 with some debug-options turned on, waiting for 
> something to happen... can I just leave it untill a window disappears 
> or do I need to manually enable something or run some user-space app?!

It depends - different options have it differently. Most simple ones are 
just compile-time, so, you don't have to enable them. Look in "help" for 
respective debug-options.

Thanks
Guennadi
---
Guennadi Liakhovetski
