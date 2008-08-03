Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYHCVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYHCVCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYHCVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:02:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42209 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbYHCVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:02:05 -0400
Date: Mon, 4 Aug 2008 00:00:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Installer
Message-ID: <20080803210051.GF7442@cs181140183.pp.htv.fi>
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:20:19AM +0530, Satish Eerpini wrote:
> Hello everyone , :
> 
> i have been writing a kernel installer which may make the kernel
> installation process a lot more easier for noobs , (don ask me why
> noobs would like to compile a kernel) ,  but atleast till they learn
> to do it the good way !
> 
> i have written some code which is below , well i am stuck at one thing , ...
> once the .config file is set , is there any method to compute the
> exact no of files that are going to be compiled ??
>...

Replacing the normal build output with something different doesn't make
anything easier.

Especially considering that your "once the .config file is set" seems to 
assume the user already configured the kernel himself...

> Thanks
> Satish

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

