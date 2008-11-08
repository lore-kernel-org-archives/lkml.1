Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYKHAak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYKHAak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKHAac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:30:32 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54375 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYKHAab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:30:31 -0500
Date: Sat, 8 Nov 2008 01:33:08 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mfd: WM8350 updates
Message-ID: <20081108003307.GC5993@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081106134254.GA21855@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106134254.GA21855@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 01:42:54PM +0000, Mark Brown wrote:
> The following changes since commit c3177623edf3fabf200c60bde9b400d03b6271f7:
>   Mark Brown (1):
>         mfd: Don't mark WM8350 security register as volatile
Pulled into my for-next branch, thanks Mark.

Cheers,
Samuel.

 
> are available in the git repository at:
> 
>   git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo
> 
> Mark Brown (4):
>       mfd: Remove i.MX31ism from WM8350 i2c driver
>       mfd: Add some documentation for WM8350 register lock
>       mfd: Add WM8350 revision H support
>       mfd: Add AUXADC support for WM8350
> 
>  drivers/mfd/wm8350-core.c             |   74 ++++++++++++++++++++++++++++++++-
>  drivers/mfd/wm8350-i2c.c              |    2 -
>  include/linux/mfd/wm8350/comparator.h |    8 ++++
>  include/linux/mfd/wm8350/core.h       |    3 +
>  4 files changed, 83 insertions(+), 4 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
