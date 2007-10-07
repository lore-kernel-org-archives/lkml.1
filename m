Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbXJGQbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbXJGQbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJGQbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:31:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57445 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbXJGQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:31:47 -0400
Date: Sun, 7 Oct 2007 18:32:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miloslav Semler <majkls@prepere.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: backport of sysfs_readdir fix from 2.6.22.y to
	2.6.16.y (CVE-2007-3104)
Message-ID: <20071007163214.GF16424@stusta.de>
References: <46FBA124.2000803@prepere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46FBA124.2000803@prepere.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch solves CVE-2007-3104  - sysfs_readdir oops.
>...

Thanks, I've applied a similar but slightly different fix in 
2.6.16.55-rc1.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

