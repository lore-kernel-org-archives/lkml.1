Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYGYVDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYGYVDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYGYVC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:02:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32905 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYGYVC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:02:57 -0400
Date: Sat, 26 Jul 2008 00:02:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, hpa <hpa@zytor.com>
Subject: Re: [PATCH] documentation: move mtrr.txt to Doc/x86/ subdir
Message-ID: <20080725210230.GB9301@cs181140183.pp.htv.fi>
References: <20080722094837.addac52a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080722094837.addac52a.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 09:48:37AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move mtrr.txt to the Documentation/x86/ subdirectory.
> Add 00-INDEX to the Documentation/x86/ subdirectory.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/00-INDEX     |    2 
>  Documentation/mtrr.txt     |  305 ---------------------------------------------
>  Documentation/x86/00-INDEX |    4 
>  Documentation/x86/mtrr.txt |  305 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 309 insertions(+), 307 deletions(-)
>...

Please also update the path in arch/x86/Kconfig

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

