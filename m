Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXEJM6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXEJM6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbXEJM6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:58:43 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49114 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761497AbXEJM6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:58:42 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 08:58:41 EDT
Date: Thu, 10 May 2007 14:49:52 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-ID: <20070510144952.1d741051@inspiron>
In-Reply-To: <20070510134850.64075278@hyperion.delvare>
References: <11785707423303-git-send-email-grant.likely@secretlab.ca>
	<20070510134850.64075278@hyperion.delvare>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 13:48:50 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> I know this isn't exactly a RTC chip, but this is still related with
> timekeeping, so wouldn't it be better placed under drivers/rtc?
> Alessandro, what do you think?

 Hi,

   I don't know if the rtc subsystem can offer help/framework
 for such a kind of driver. maybe it could be extended to 
 incorporate it. probably the alarms could be handled
 in some way.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

