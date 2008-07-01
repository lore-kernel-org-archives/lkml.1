Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYGAUqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYGAUqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYGAUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:46:39 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39823 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYGAUqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:46:38 -0400
Date: Tue, 1 Jul 2008 23:46:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 27/60] microblaze_v4: virtualization
Message-ID: <20080701204617.GE32598@cs181140183.pp.htv.fi>
References: <1214483429-32360-19-git-send-email-monstr@seznam.cz> <1214483429-32360-20-git-send-email-monstr@seznam.cz> <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz> <1214483429-32360-28-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214483429-32360-28-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:56PM +0200, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  include/asm-microblaze/kvm.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-microblaze/kvm.h
> 
> diff --git a/include/asm-microblaze/kvm.h b/include/asm-microblaze/kvm.h
> new file mode 100644
> index 0000000..01c5e79
> --- /dev/null
> +++ b/include/asm-microblaze/kvm.h
> @@ -0,0 +1 @@
> +/* Microblaze does not support KVM */

There's a patch pending for 2.6.27 that will remove the requirement for 
this empty header.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

