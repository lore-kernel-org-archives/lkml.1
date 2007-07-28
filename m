Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbXG1P1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbXG1P1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXG1P1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:27:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47291 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752123AbXG1P13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:27:29 -0400
Date: Sat, 28 Jul 2007 17:27:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@osdl.org>, Roy Zang <tie-fei.zang@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [2.6 patch] arch/powerpc/Kconfig: fix the EMBEDDED6xx
	dependencies
Message-ID: <20070728152704.GA30976@stusta.de>
References: <20061201115410.GV11084@stusta.de> <17779.37050.4039.942954@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17779.37050.4039.942954@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 04, 2006 at 02:06:34PM +1100, Paul Mackerras wrote:
> Adrian Bunk writes:
> 
> > This patch changes the EMBEDDED6xx dependencies to the equivalent 
> > dependency that seems to have been intended.
> 
> Nack - CONFIG_EMBEDDED6xx is going away entirely, soon.

Still there - and still with this strange dependency.

> Paul.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

