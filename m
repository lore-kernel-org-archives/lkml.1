Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXJYSuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXJYSuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXJYSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:49:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45063 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbXJYSty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:49:54 -0400
Date: Thu, 25 Oct 2007 20:50:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Lothian <mike@fireburn.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
Message-ID: <20071025185022.GP30533@stusta.de>
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 07:33:35PM +0100, Michael Lothian wrote:
> Hi
> 
> I was wondering if it was possible to add -march=native support to the
> processor options of the new x86 architecture if gcc 4.2 or greater is being
> used.
> 
> I'm not suggesting this should be a default at all, merely an extra option
> similar to selecting P4, Athlon or even -Os.
> 
> I've manually tried this flag at home with no ill effects.

Selecting your CPU in the kernel configuration has more effects than 
just setting the gcc flag, so it wouldn't gain you anything since you 
anyway have to choose the correct CPU.

> Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

