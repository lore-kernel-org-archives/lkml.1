Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYEEOYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYEEOYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYEEOYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:24:30 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:26939 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbYEEOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:24:29 -0400
Message-ID: <fa686aa40805050724w59d4357ak6029a2a7a612329e@mail.gmail.com>
Date: Mon, 5 May 2008 08:24:28 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 04/56] microblaze_v2: Open firmware files
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       microblaze-uclinux@itee.uq.edu.au, "Michal Simek" <monstr@monstr.eu>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
X-Google-Sender-Auth: 76080ffcedbd8798
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 5:40 AM,  <monstr@seznam.cz> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
>
>  Signed-off-by: Michal Simek <monstr@monstr.eu>
>  ---
>   arch/microblaze/kernel/prom.c        | 1653 ++++++++++++++++++++++++++++++++++
>   include/asm-microblaze/of_device.h   |   41 +
>   include/asm-microblaze/of_platform.h |   45 +
>   include/asm-microblaze/prom.h        |  311 +++++++

another mostly-clone from arch/powerpc/kernel.  Is anyone working on
moving the guts of this file to a common location?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
