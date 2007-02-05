Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXBEIJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXBEIJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 03:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXBEIJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 03:09:44 -0500
Received: from mail.velocitynet.com.au ([203.17.154.25]:45286 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXBEIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 03:09:43 -0500
Message-ID: <45C6E63D.3040505@iinet.net.au>
Date: Mon, 05 Feb 2007 19:09:33 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: "Wu, Bryan" <Bryan.Wu@analog.com>
CC: akpm@osdl.org, arnd@arndb.de, rdunlap@xenotime.net, rdreier@cisco.com,
       castet.matthieu@free.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Blackfin: architecture patch against Linux kernel
 2.6.20
References: <D3664A3D9376A94BB603EE19E4AA246D10D64758@nwd2exm4.ad.analog.com>
In-Reply-To: <D3664A3D9376A94BB603EE19E4AA246D10D64758@nwd2exm4.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Bryan wrote:
> Hi everyone,
> 
> This is the Blackfin architecture patch against Linux kernel 2.6.20,
> again. As we promised, some issues are fixed in the latest release with
> the help from lkml.
> 
> The blackfin-arch patch is at 
> https://blackfin.uclinux.org/gf/download/frsrelease/25/2490/blackfin-arc
> h-linux-2.6.20.patch
> Which, at 1.9M bytes, is too large to attach here. Please let me know if
> you want me to do it anyway.
> 
Hi again, I just noticed that all your patches are generated 2 levels 
down (patch -p2 to apply).  It isn't too hard to specify -p2 rather than 
-p1, but it just isn't The Way ;)

If you could regenerate the patches just one level down that'd be great, 
cheers.

Ben.
