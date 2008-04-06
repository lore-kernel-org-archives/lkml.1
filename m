Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYDFVvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYDFVvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYDFVv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:51:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38022 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYDFVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:51:27 -0400
Date: Mon, 7 Apr 2008 00:50:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata/sata_via.c - Eliminate "may be used
	uninitialized" warning
Message-ID: <20080406215054.GI30987@cs181133002.pp.htv.fi>
References: <1207518320.1803.52.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1207518320.1803.52.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 02:45:20PM -0700, Joe Perches wrote:
> Called by svia_init_one with a temporary,
> so there's no effective code change.
>...

I'm not getting any warning here.

Are you using an older gcc?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

