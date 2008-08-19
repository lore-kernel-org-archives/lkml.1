Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYHSNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYHSNpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYHSNp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:45:28 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56853 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbYHSNp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:45:27 -0400
Date: Tue, 19 Aug 2008 16:45:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@karaya.com, viro@zeniv.linux.org.uk
Subject: Re: hppfs; CONFIG_HPPFS; used ?? or orphaned??
Message-ID: <20080819134517.GB8852@cs181140183.pp.htv.fi>
References: <ac9c93b10808190638q16fb54d6uef68548b7e5fd526@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac9c93b10808190638q16fb54d6uef68548b7e5fd526@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 03:38:37PM +0200, Frans Meulenbroeks wrote:
> While roaming through the fs tree I bumped upon the directory hppfs (not hpfs!)
> 
> Is this one orphaned?
> I saw that the Makefile references CONFIG_HPPFS, but I could not find
> it in a Kconfig file
>...

$ grep -r HPPFS *
arch/um/Kconfig:config HPPFS
...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

