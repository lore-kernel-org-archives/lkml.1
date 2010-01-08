Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368Ab0AHIAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0AHIAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489Ab0AHIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:00:24 -0500
Received: from darkstar.wilibox.com ([195.14.175.138]:46586 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0AHIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:00:23 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 03:00:23 EST
Message-ID: <4B46E3C3.2080303@gmail.com>
Date: Fri, 08 Jan 2010 09:50:27 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-samsung-soc@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Please pull bjdooks' for-linus/samsung
References: <E1NT4JR-0006WN-6J@trinity.fluff.org>
In-Reply-To: <E1NT4JR-0006WN-6J@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 04:10 AM, Ben Dooks wrote:
> The following changes since commit c5974b835a909ff15c3b7e6cf6789b5eb919f419:
>    Linus Torvalds (1):
>          Merge branch 'limits_cleanup' of git://decibel.fi.muni.cz/~xslaby/linux
>
> are available in the git repository at:
>
>    git://git.fluff.org/bjdooks/linux.git for-linus/samsung
>
> Ben Dooks (1):
>        ARM: S3C64XX: Fix possible clock look in EPLL and MPLL clock chains

Spelling look/lock

>
>   arch/arm/plat-s3c64xx/s3c6400-clock.c |   10 +---------
>   1 files changed, 1 insertions(+), 9 deletions(-)

