Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbXCaVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbXCaVCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXCaVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:02:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39498 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797AbXCaVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:02:33 -0400
Date: Sat, 31 Mar 2007 23:02:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen.Clark@seclark.us, linux-kernel <linux-kernel@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
Message-ID: <20070331210232.GD14134@stusta.de>
References: <460EC109.5070300@seclark.us> <20070331134610.64a9c410.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070331134610.64a9c410.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 01:46:10PM -0700, Andrew Morton wrote:
> On Sat, 31 Mar 2007 16:14:01 -0400 Stephen Clark <Stephen.Clark@seclark.us> wrote:
>...
> > Also it sets my hard
> > drive to udma/33 when it run find at udma/66 under 2.6.20.1.
> 
> #3.  Hopefully it's related to #2.
>...

No, this sounds like

Subject    : libata: PATA UDMA/100 configured as UDMA/33
References : http://lkml.org/lkml/2007/2/20/294
             http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
             http://bugzilla.kernel.org/show_bug.cgi?id=8133
             http://bugzilla.kernel.org/show_bug.cgi?id=8164
             http://lkml.org/lkml/2007/3/21/330
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
             Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
             Laurent Riffard <laurent.riffard@free.fr>
             Lukas Hejtmanek <xhejtman@mail.muni.cz>
Fixed-By   : Tejun Heo <htejun@gmail.com>
Commit     : 8c3c52a8f00536ce55dafa055b4a211f878f3901
Status     : fixed in -rc6


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

