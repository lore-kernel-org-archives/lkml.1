Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYLAWcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYLAWcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYLAWcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:32:17 -0500
Received: from mx0.towertech.it ([213.215.222.73]:49048 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751324AbYLAWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:32:16 -0500
Date: Mon, 1 Dec 2008 23:32:10 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: lkml@rtr.ca, Len Brown <lenb@kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [rtc-linux] Re: PATCH: /proc/acpi/alarm: handle day-of-month
 wraparound on readback
Message-ID: <20081201233210.598f2dcf@i1501.lan.towertech.it>
In-Reply-To: <49346212.3050102@rtr.ca>
References: <200806222042.13929.david-b@pacbell.net>
	<4934176F.6080900@rtr.ca>
	<alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>
	<49346212.3050102@rtr.ca>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 17:15:46 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Yeah.. bit of a nuisance that.
> I regularly apply this patch to my own kernels:

 While it will certainly work, maybe it's time to switch
 to /sys/class/rtc/rtcX/wakealarm . 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

