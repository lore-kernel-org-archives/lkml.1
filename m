Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZDWPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZDWPqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZDWPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:46:43 -0400
Received: from mx0.towertech.it ([213.215.222.73]:59401 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751064AbZDWPqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:46:43 -0400
Date: Thu, 23 Apr 2009 17:46:41 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Message-ID: <20090423174641.2b03e7a7@i1501.lan.towertech.it>
In-Reply-To: <20090424.002900.11623503.anemo@mba.ocn.ne.jp>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	<20090423170253.6b6dfd21@i1501.lan.towertech.it>
	<20090424.002900.11623503.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 00:29:00 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

>   Are you willing to make some tests in that direction with your
> >  drivers?  
> 
> Yes, if we had consensus of the API change.  But since all my drivers
> have IRQF_DISABLED and I don't want to drop them, I'm not a good
> tester for this ;)

 Is not an API change, we are gradually relaxing it if it
 proves workable :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

