Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZKBLQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZKBLQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZKBLQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:16:34 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:45430 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZKBLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:16:33 -0500
X-Greylist: delayed 1122 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 06:16:33 EST
Date: Mon, 2 Nov 2009 13:57:50 +0300
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Steffen Sledz <sledz@dresearch.de>, Steffen Sledz <sledz@zone42.org>
Cc: sledz@dresearch.de, wd@denx.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Patch: Fix userland build failure in linux/if_tunnel.h
Message-ID: <20091102135750.436a7b54@emcraft.com>
In-Reply-To: <4AEDCBA6.7040206@dresearch.de>
References: <4AEDCBA6.7040206@dresearch.de>
Organization: Emcraft Systems
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steffen,

Hm, I received a confirmation, that my fix was applied
http://www.spinics.net/lists/netdev/msg103860.html

However, it indeed didn't find their way into the mainline.
I have no idea why, received no objections.

I'm sending the reply to the resp. mailing lists too; hope you don't
mind.

Regards,
Sergei

On Sun, 01 Nov 2009 18:55:50 +0100
Steffen Sledz <sledz@dresearch.de> wrote:

> Hello Sergei,
> 
> i'm working for the OpenEmbedded project and we hit the same busybox
> problem you mentioned in <http://patchwork.kernel.org/patch/31164/>.
> 
> It doesn't look like you got much feedback on you patch suggestion.
> Did it made it's way to the kernel sources? Or where there any
> objections on it?
> 
> Steffen

