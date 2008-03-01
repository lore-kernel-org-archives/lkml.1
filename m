Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYCAQQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYCAQQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYCAQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:16:41 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38851 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbYCAQQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:16:41 -0500
Date: Sat, 1 Mar 2008 18:15:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, sfrench@samba.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][fs/cifs/cifsfs.c] Make use of cifs_xquota_get
Message-ID: <20080301161515.GD25835@cs181133002.pp.htv.fi>
References: <47B08A0B.4020604@tiscali.nl> <20080301093712.GB25835@cs181133002.pp.htv.fi> <524f69650803010806m1571df8fiff4b9587b7bf1cc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <524f69650803010806m1571df8fiff4b9587b7bf1cc7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 10:06:11AM -0600, Steve French wrote:
> There are quite a few fixes stuck in cifs-2.6.git that are fine to be
> merged with mainline but didn't want to bug Linus with multiple merge
> requests (there are a couple of more fixes that are not in
> cifs-2.6.git pending review)

I just realize that this specific bug is in code that is not (yet?) 
available for users at all, so my email was a bit bogus.

But generally please try to get fixes to Linus early - and having a few 
more weeks for getting fixes tested is more important than how often 
Linus pulls from you.

> Thanks,
> 
> Steve

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

