Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbZIDRDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbZIDRDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbZIDRDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:03:45 -0400
Received: from mx0.towertech.it ([213.215.222.73]:47539 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932873AbZIDRDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:03:44 -0400
Date: Fri, 4 Sep 2009 19:03:45 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
 attribute
Message-ID: <20090904190345.02733404@i1501.lan.towertech.it>
In-Reply-To: <20090904165549.GA25802@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
	<1252081568-6000-2-git-send-email-mjg@redhat.com>
	<20090904182528.591dbd29@i1501.lan.towertech.it>
	<20090904163029.GA25239@srcf.ucam.org>
	<20090904183828.4376236e@i1501.lan.towertech.it>
	<20090904164127.GB25419@srcf.ucam.org>
	<20090904185243.53c9b440@i1501.lan.towertech.it>
	<20090904165549.GA25802@srcf.ucam.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 17:55:49 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Sep 04, 2009 at 06:52:43PM +0200, Alessandro Zummo wrote:
> 
> >  that's ok, but nonetheless there's a problem in hwclock
> >  if it takes 3 secs to read the time.
> 
> The 3-second case is with virtualised access to the cmos, but you're 
> right that it does sound excessive. Even so, it seems like a win to be 
> able to avoid running code that the kernel's already run

 ok. I find boot_timesource to be not intuitive. I'd
 vote for hctosys or something like that.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

