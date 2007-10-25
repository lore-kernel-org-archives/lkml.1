Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXJYTRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXJYTRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXJYTQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:16:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60662 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893AbXJYTQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:16:54 -0400
Date: Thu, 25 Oct 2007 21:17:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Lothian <mike@fireburn.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
Message-ID: <20071025191723.GQ30533@stusta.de>
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com> <20071025185022.GP30533@stusta.de> <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 08:09:56PM +0100, Michael Lothian wrote:
> Actually I changed the Makefile.cpu and changed the -march to native
> which did slightly change the size of the kernel (slightly larger I
> think)
> 
> So what else does that option change?

Look at arch/i386/Kconfig.cpu

> Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

