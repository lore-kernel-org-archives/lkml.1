Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYKFRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYKFRnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYKFRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:42:54 -0500
Received: from mx0.towertech.it ([213.215.222.73]:60563 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751225AbYKFRmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:42:54 -0500
Date: Thu, 6 Nov 2008 18:42:46 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: mpfj@mimc.co.uk, dbrownell@users.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [rtc-linux] [PATCH v6] Add Dallas DS1390/93/94 RTC chips
Message-ID: <20081106184246.53950fa0@i1501.lan.towertech.it>
In-Reply-To: <4912B459.2020704@mimc.co.uk>
References: <4912B459.2020704@mimc.co.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 09:09:45 +0000
Mark Jackson <mpfj@mimc.co.uk> wrote:

> v6 (!!) of this patch with even more code tidying as per previous comments.

 I know.. I'm becoming stricter and stricter as the time goes by.. 

> Also only a single tx/rx buffer is used.
> Now uses spi_write_then_read()
> Comments changed to include extra chips in the family
> 
> This patch adds support for the Dallas DS1390/93/94 SPI RTC chip.

 There's still one printk left that you can avoid :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

