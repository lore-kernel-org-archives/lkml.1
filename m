Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZCJJkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZCJJkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCJJj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:39:56 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49009 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753510AbZCJJjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:39:54 -0400
Date: Tue, 10 Mar 2009 10:39:48 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Geert.Uytterhoeven@sonycom.com, Geoff Levand <geoffrey.levand@am.sony.com>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>
Subject: Re: [rtc-linux] Re: [PATCH 7/7] powerpc/ps3: Add rtc-ps3
Message-ID: <20090310103948.6e180eea@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0903101015470.24318@vixen.sonytel.be>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<49B5618E.9050501@am.sony.com>
	<alpine.LRH.2.00.0903101015470.24318@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 10:21:14 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Alessandro prefers not to have generic RTC drivers on top of some other
> abstraction, but wants platform/chip-specific drivers under drivers/rtc/
> instead. The goal is to convert all RTC drivers buried in platform code
> to separate RTC drivers.
> 
> (Alessandro, please correct me if I'm wrong)

 yes, that's my dream :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

