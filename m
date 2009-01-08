Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbZAHWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbZAHWyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbZAHWyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:54:33 -0500
Received: from mx0.towertech.it ([213.215.222.73]:49725 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754333AbZAHWyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:54:32 -0500
Date: Thu, 8 Jan 2009 23:54:28 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: broonie@opensource.wolfsonmicro.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc: Convert wm8350 use new alarm and
 update operations
Message-ID: <20090108235428.159939ba@i1501.lan.towertech.it>
In-Reply-To: <1231334069-12072-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1231334069-12072-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Jan 2009 13:14:29 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> These are the only two ioctls so the ioctl() function is also removed.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

