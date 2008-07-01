Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYGAOMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYGAOMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYGAOMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:12:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46596 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYGAOMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:12:18 -0400
Date: Tue, 1 Jul 2008 16:11:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-linu@fluff.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] i2c pull request for s3c24xx driver
Message-ID: <20080701161127.16724c11@hyperion.delvare>
In-Reply-To: <20080701133739.GA7933@fluff.org.uk>
References: <20080701133739.GA7933@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Linus,

On Tue, 1 Jul 2008 14:37:39 +0100, Ben Dooks wrote:
> Pull request for i2c driver fixes to the S3C24XX i2c driver
> suitable for applying to the current kernel.
> 
> Linus please take this unless Jean wants to pull this into
> his own i2c tree.

I'm totally fine with Linus pulling from your git tree directly.
That's less work for me, and you're the i2c subsystem co-maintainer
now. The whole point of you becoming a co-maintainer was that you could
offload some work from me.

> 
> The following changes since commit e1441b9a41c33aa9236008a7cfe49a8e723fb397:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
> 
> are available in the git repository at:
> 
>   git://aeryn.fluff.org.uk/bjdooks/linux.git i2c-fix
> 
> Ben Dooks (3):
>       I2C: S3C2410: Check ACK on byte transmission
>       I2C: S3C2410: Fixup error codes returned rom a transfer.
>       I2C: S3C2410: Add MODULE_ALIAS() for s3c2440 device.
> 
>  drivers/i2c/busses/i2c-s3c2410.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)

Thanks,
-- 
Jean Delvare
