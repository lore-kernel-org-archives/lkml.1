Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXFOS1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXFOS1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXFOS0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:26:54 -0400
Received: from mx0.towertech.it ([213.215.222.73]:39988 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752456AbXFOS0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:26:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 14:26:52 EDT
Date: Fri, 15 Jun 2007 20:19:59 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org, a.zummo@towertech.it
Subject: Re: [rtc-linux] RTC_CLASS is still considered as EXPERIMENTAL?
Message-ID: <20070615201959.26666815@inspiron>
In-Reply-To: <20070616.011037.59464869.anemo@mba.ocn.ne.jp>
References: <20070616.011037.59464869.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007 01:10:37 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> 
> The generic RTC subsystem was added to kernel 2.6.17 which was
> released a years ago.  Since then, many drivers were added to the
> subsystem without major API changes, I think.
> 
> It is mature enough to remove EXPERIMENTAL label from RTC_CLASS, isn't
> it?

 I'd say yes, I will submit a patch. ty.
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

