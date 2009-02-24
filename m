Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZBXWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZBXWMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZBXWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:12:04 -0500
Received: from mx0.towertech.it ([213.215.222.73]:58513 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759159AbZBXWMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:12:01 -0500
Date: Tue, 24 Feb 2009 23:11:54 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       rtc-linux@googlegroups.com, Richard Zidlicky <rz@linux-m68k.org>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090224231154.60ba18d6@i1501.lan.towertech.it>
In-Reply-To: <1235511327.18632.73.camel@macbook.infradead.org>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	<1235511327.18632.73.camel@macbook.infradead.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 06:35:27 +0900
David Woodhouse <dwmw2@infradead.org> wrote:

> > So you want us to kill the ppc_md.[gs]et_rtc_time() [ppc], mach_hwclk() [m68k],
> > mach_gettod() [m68knommu] (and probably a few other) abstractions, and move all
> > RTC code out of arch/ into seperate drivers under drivers/rtc/ instead?
> 
> That's the ideal... although did we get NTP sync working again yet?

 not yet. we're close but I've been very busy :(
 
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

