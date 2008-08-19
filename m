Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYHSNqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYHSNqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYHSNqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:46:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56910 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYHSNqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:46:20 -0400
Date: Tue, 19 Aug 2008 16:46:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: openpromfs; CONFIG_SUN_OPENPROMFS; used ?? or orphaned??
Message-ID: <20080819134609.GC8852@cs181140183.pp.htv.fi>
References: <ac9c93b10808190643yc7f9f1dtaf69bff474560e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac9c93b10808190643yc7f9f1dtaf69bff474560e9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 03:43:22PM +0200, Frans Meulenbroeks wrote:
> While roaming through the fs tree I bumped upon the directory openpromfs
> 
> Is this one orphaned?
> I saw that the Makefile references CONFIG_SUN_OPENPROMFS, but I could not find
> it in a Kconfig file
>...

$ grep -r SUN_OPENPROMFS *
arch/sparc/Kconfig:config SUN_OPENPROMFS
...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

