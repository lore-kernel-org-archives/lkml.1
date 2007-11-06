Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXKFFgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXKFFgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXKFFgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:36:09 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46849 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbXKFFgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:36:08 -0500
Date: Tue, 6 Nov 2007 06:35:44 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: a list of non-existent but included include/linux header files
Message-ID: <20071106053544.GH3444@stusta.de>
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 11:31:39PM -0500, Robert P. J. Day wrote:
> 
>   this list is short enough that i'll just post it here -- attempts to
> include header files under include/linux when those header files
> simply don't exist.  obviously, there might be false positives for one
> reason or another.  (the only manual culling i did of the list was to
> remove inclusions of autoconf.h and utsrelease.h -- i assumed those
> weren't an issue for anyone.)
>...
> === Missing: include/linux/compile.h ===
> arch/x86/boot/version.c:#include <linux/compile.h>
> init/version.c:#include <linux/compile.h>
>...

That's a generated header.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

