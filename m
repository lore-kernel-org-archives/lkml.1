Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXI0GxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXI0GxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXI0GxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:53:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39536 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703AbXI0GxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:53:13 -0400
Date: Thu, 27 Sep 2007 08:53:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <david@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070927065333.GW6800@stusta.de>
References: <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070926215521.GU6800@stusta.de> <46FAECC5.8040103@davidnewall.com> <20070927000137.GV6800@stusta.de> <46FB50ED.5000809@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46FB50ED.5000809@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:53PM +0930, David Newall wrote:
> Adrian Bunk wrote:
>> You claimed:
>>
>> <--  snip  -->
>>
>> Look, when chroot was being designed, I think they intended that even root 
>> should be unable to get out. They went so far as to say that dot-dot 
>> wouldn't let you out; and it doesn't.
>>
>> <--  snip  -->
>>
>> You were clearly saying that whom you call "they" were the people who 
>> designed chroot. And it was you who was claiming in this statement that
>> "they" said it.
>
> You've ignored the operative phrase, "I think".

So you start a paragraph with "Look, when chroot was being designed" and 
all the contents of this paragraph only comes from your imagination and 
contradicts the facts...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

