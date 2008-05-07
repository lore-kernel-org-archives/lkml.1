Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYEGMck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYEGMck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYEGMcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:32:21 -0400
Received: from hosted02.westnet.com.au ([203.10.1.213]:40434 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYEGMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:32:19 -0400
Message-ID: <4821A146.9090605@snapgear.com>
Date: Wed, 07 May 2008 22:32:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] m68knommu: remove example defconfig
References: <200805070125.m471PwNj023237@goober> <20080507063201.GB30082@cs181133002.pp.htv.fi>
In-Reply-To: <20080507063201.GB30082@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, May 07, 2008 at 11:25:58AM +1000, Greg Ungerer wrote:
> 
>> Remove the old example m68knommu defconfig.
>> ...
> 
> Please use KBUILD_DEFCONFIG to define a default defconfig after this.
> 
> Simply add to arch/m68knommu/Makefile
>   KBUILD_DEFCONFIG := m5208evb_defconfig
> (replace m5208evb_defconfig with whichever you prefer).

Yep, I'll fix that up.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
