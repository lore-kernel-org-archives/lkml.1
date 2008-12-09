Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYLIKD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYLIKD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYLIKDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:03:17 -0500
Received: from mx0.towertech.it ([213.215.222.73]:48591 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752535AbYLIKDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:03:16 -0500
Date: Tue, 9 Dec 2008 11:02:59 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sameo@openedhand.com,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] rtc twl4030: rename ioctl function when
 RTC_INTF_DEV=n
Message-ID: <20081209110259.5941ef1b@i1501.lan.towertech.it>
In-Reply-To: <493732D3.4020902@xenotime.net>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<493732D3.4020902@xenotime.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 17:30:59 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build error when RTC_INTF_DEV=n:
> 
> drivers/rtc/rtc-twl4030.c:402: error: 'twl4030_rtc_ioctl' undeclared here (not in a function)
> make[3]: *** [drivers/rtc/rtc-twl4030.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

