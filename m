Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbXFKQnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbXFKQnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXFKQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:43:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:4471 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXFKQnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AdPN8Q9LiHf4XXijQnsOOBCCdNtGpOapnaWNVpZY1Q7r8CgK4Igkj1Bh+HibrCZ/OhCKCm110a3LCIfW5AYe/ZY8SdU1ye7OsGG2UAPdc7rXoHDfeRduS9HRxWhwgOhQxCn5OqpirSjHYfK8J6icqOpwXd3Wkd1yeHEg3r5u264=
Message-ID: <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
Date: Mon, 11 Jun 2007 18:43:21 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 11 Jun 2007, Haavard Skinnemoen wrote:
>
> > While trying to get SLUB debugging to not break DMA on AVR32, I ran
> > into this:
>
> This is a known bug in 2.6.22-rc2/rc3. Which version are you running?

2.6.22-rc4. I did a pull from Linus' tree a few hours ago.

Haavard
