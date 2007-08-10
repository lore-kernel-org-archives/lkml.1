Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbXHJCoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbXHJCoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbXHJCoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:44:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42085 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbXHJCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:44:36 -0400
Date: Fri, 10 Aug 2007 04:44:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: JFFS2/mtdsuper modprobe "unknown symbol" in 2.6.23-rc1
Message-ID: <20070810024422.GF18938@stusta.de>
References: <200708100238.l7A2cIZm024347@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200708100238.l7A2cIZm024347@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:38:18PM -0400, Erez Zadok wrote:
> I'm getting an error modprobing jffs2 due to mtdsuper failing to insmod:
>...
> Does anyone know what am I missing?

You miss that 2.6.23-rc2 with this bug fixed has already been released.

> Thanks,
> Erez.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

