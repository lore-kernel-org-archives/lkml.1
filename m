Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYJPPQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYJPPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYJPPQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:16:07 -0400
Received: from mx0.towertech.it ([213.215.222.73]:51489 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753517AbYJPPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:16:04 -0400
Date: Thu, 16 Oct 2008 17:15:54 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: jekhor@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc-s3c: Fix section mismatch warnings
Message-ID: <20081016171554.1ed8dd0f@i1501.lan.towertech.it>
In-Reply-To: <1224169301-18018-1-git-send-email-jekhor@gmail.com>
References: <1224169301-18018-1-git-send-email-jekhor@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 18:01:41 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> 
> Warnings was appeared when compile rtc-s3c.c because
> platform_driver structure s3c2410_rtcdrv has wrong name.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>

 -ENOPATCH :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

