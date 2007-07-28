Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbXG1GP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbXG1GP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXG1GPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:15:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47023 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754762AbXG1GPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:15:48 -0400
Date: Sat, 28 Jul 2007 08:15:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm/sparse.c:482: error: =?utf-8?Q?impl?=
	=?utf-8?Q?icit_declaration_of_function_=E2=80=98sparse=5Fearly=5Fusemap?=
	=?utf-8?B?X2FsbG9j4oCZ?=
Message-ID: <20070728061523.GG15129@stusta.de>
References: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:00:54PM -0700, Miles Lane wrote:
> Do you need my .config file?

Please always send the .config - it makes reproducing an error and 
verifying a fix much easier.

This list has a 400 kB per email limit, and as long as you don't hit 
this limit you have never sent too much information.

>   CC      mm/sparse.o
> mm/sparse.c: In function 'sparse_init':
> mm/sparse.c:482: error: implicit declaration of function
> 'sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/sparse.o] Error 1

The .config also tells which kernel you are using.

This doesn't seem to be Linus' tree.
This seems to be 2.6.23-rc1-mm1?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

