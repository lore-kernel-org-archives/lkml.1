Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYJ1KUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYJ1KUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYJ1KUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:20:22 -0400
Received: from mx0.towertech.it ([213.215.222.73]:34550 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752799AbYJ1KUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:20:20 -0400
Date: Tue, 28 Oct 2008 11:20:07 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] RTC S3C: Add device_init_wakeup() invokation
Message-ID: <20081028112007.449103c7@i1501.lan.towertech.it>
In-Reply-To: <1224758815-23131-1-git-send-email-jekhor@gmail.com>
References: <1224758815-23131-1-git-send-email-jekhor@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 13:46:55 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> This patch adds device_init_wakeup() ivokation to probe function of
> s3c2410_rtc_driver. Without of this wakealarm sysfs attribute does not
> initialise.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

