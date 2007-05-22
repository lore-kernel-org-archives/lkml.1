Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbXEVAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbXEVAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbXEVAdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:33:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47041 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762042AbXEVAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:33:12 -0400
Message-ID: <46523A41.2060608@garzik.org>
Date: Mon, 21 May 2007 20:33:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dave Airlie <airlied@gmail.com>, Jon Smirl <jonsmirl@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	<9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>	<200705210914.22663.jbarnes@virtuousgeek.org>	<200705210934.58559.jbarnes@virtuousgeek.org>	<9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>	<21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>	<4652295E.7060305@garzik.org> <20070522013545.5c269641@the-village.bc.nu>
In-Reply-To: <20070522013545.5c269641@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> the kernel, it can be a lot smaller than X and auditable.. sticking
>>> the DRI protocol in the kernel is just pointless..
>> It is a quite sensible idea.
>>
>> The userspace X server SHOULD be running under a non-root user, with 
>> appropriate fine-grained privs granted to it.
>>
>> "I need root to do graphics" is a myopic, antiquated view of the world.
> 
> X server: priviledges below everything, pageable
> kernel: priviledges as high as conceivable, non-pageable
> 
> So why do you want it in kernel.... security is not the sensible answer
> here.

Replying/quoting mixup.  I was responding to the root-privs userspace 
aspect, not the "put it in the kernel" aspect.

I do not want it in the kernel (should have snipped that last quoted line).

	Jeff



