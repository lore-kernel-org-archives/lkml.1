Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbYFZOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbYFZOjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbYFZOjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:39:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52849 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760264AbYFZOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:39:23 -0400
Date: Thu, 26 Jun 2008 17:37:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 30/60] microblaze_v4: support for a.out
Message-ID: <20080626143713.GE30954@cs181140183.pp.htv.fi>
References: <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz> <1214483429-32360-28-git-send-email-monstr@seznam.cz> <1214483429-32360-29-git-send-email-monstr@seznam.cz> <1214483429-32360-30-git-send-email-monstr@seznam.cz> <1214483429-32360-31-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214483429-32360-31-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:59PM +0200, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-microblaze/a.out.h
> 
> diff --git a/include/asm-microblaze/a.out.h b/include/asm-microblaze/a.out.h
> new file mode 100644
> index 0000000..e69de29

As of 2.6.26-rc7 you do no longer need this header.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

