Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbXCRQVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbXCRQVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXCRQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:21:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34237 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbXCRQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:21:50 -0400
Date: Sun, 18 Mar 2007 17:21:53 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21-rc4]  misc doc and kconfig typos
Message-ID: <20070318162153.GS752@stusta.de>
References: <20070317144451.6c83cf3b.kernel1@cyberdogtech.com> <20070317215903.7fc0da46.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070317215903.7fc0da46.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 09:59:03PM -0700, Randy Dunlap wrote:
> On Sat, 17 Mar 2007 14:44:51 -0400 Matt LaPlante wrote:
> 
> > Fix various typos in kernel docs and Kconfigs, 2.6.21-rc4.
> > 
> > Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks, Matt.
> 
> BTW, I would prefer to see doc and kconfig patches in separate
> files.  Anyone else pro or con on that?

IMHO mixing typo fixes in comments, help texts and docs is not a problem 
since they are treated the same way and shouldn't be able to cause any 
breakage.

> ~Randy

Your monkey
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

