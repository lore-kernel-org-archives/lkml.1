Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYJUSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYJUSmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJUSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:41:55 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60789 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751548AbYJUSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:41:55 -0400
Date: Tue, 21 Oct 2008 20:41:51 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] rtc-s3c: Fix section mismatch warnings
Message-ID: <20081021204151.7b96b55d@i1501.lan.towertech.it>
In-Reply-To: <1224172110-24905-1-git-send-email-jekhor@gmail.com>
References: <20081016171554.1ed8dd0f@i1501.lan.towertech.it>
	<1224172110-24905-1-git-send-email-jekhor@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 18:48:30 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> Warnings was appeared when compile rtc-s3c.c because
> platform_driver structure s3c2410_rtcdrv has wrong name.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>

 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

