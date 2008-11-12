Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYKLWGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYKLWGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKLWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:06:21 -0500
Received: from mx0.towertech.it ([213.215.222.73]:33927 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751595AbYKLWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:06:21 -0500
Date: Wed, 12 Nov 2008 23:06:17 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2008-11-10-14-54 uploaded (RTC)
Message-ID: <20081112230617.1f2d1857@i1501.lan.towertech.it>
In-Reply-To: <20081112132905.289e9c69.rdunlap@xenotime.net>
References: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
	<20081112132905.289e9c69.rdunlap@xenotime.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 13:29:05 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> 
> drivers/rtc/rtc-dev.c contains 2 duplicated switch cases:
> 
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c: In function 'rtc_dev_ioctl':
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:421: error: duplicate case value
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:372: error: previously used here
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:426: error: duplicate case value
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:368: error: previously used here

 my fault, fix will follow.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

