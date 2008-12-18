Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752792AbYLRQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYLRQwy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLRQwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:52:44 -0500
Received: from mx0.towertech.it ([213.215.222.73]:56066 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750892AbYLRQwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:52:44 -0500
Date: Thu, 18 Dec 2008 17:52:14 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH V2 4/7] rtc: PCF50633 rtc driver
Message-ID: <20081218175214.3550dfdd@i1501.lan.towertech.it>
In-Reply-To: <20081218151142.GA2284@cff.thadambail>
References: <20081218055618.31696.65002.stgit@cff.thadambail>
	<20081218055726.31696.80688.stgit@cff.thadambail>
	<20081218100310.385bb808@i1501.lan.towertech.it>
	<20081218151142.GA2284@cff.thadambail>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 20:41:43 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

>  > +	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_ALARM);
> > > +	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_SECOND);  
> > 
> >  please remove rtc before unregistering
> >   
> 
> Sorry, didn't get you meant.
> 
> Thank you for the review.

 my fault. s/rtc/irq/


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

