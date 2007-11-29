Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXK2SRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXK2SRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXK2SQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:16:34 -0500
Received: from mx0.towertech.it ([213.215.222.73]:36589 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932770AbXK2SQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:16:33 -0500
Date: Thu, 29 Nov 2007 19:14:21 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, rtc-linux@googlegroups.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071129191421.29d44e9a@i1501.lan.towertech.it>
In-Reply-To: <200711291010.12707.david-b@pacbell.net>
References: <20070920103225.GA4410@elf.ucw.cz>
	<200709212238.05130.david-b@pacbell.net>
	<20071128232647.GC4947@elf.ucw.cz>
	<200711291010.12707.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 10:10:12 -0800
David Brownell <david-b@pacbell.net> wrote:

> 
> I think the right thing to do there is just insist that in the RTC
> framework, alarms should always follow the one-shot model.

 /me agrees.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

