Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZB0RSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZB0RSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZB0RRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:17:50 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:43420 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZB0RRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:17:48 -0500
Date: Fri, 27 Feb 2009 17:17:36 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
cc: rtc-linux@googlegroups.com, Geert.Uytterhoeven@sonycom.com,
       David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
In-Reply-To: <20090225111836.621412c1@i1501.lan.towertech.it>
Message-ID: <alpine.LFD.1.10.0902270142360.22096@ftp.linux-mips.org>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090220170454.04382e9e@i1501.lan.towertech.it> <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be> <1235511327.18632.73.camel@macbook.infradead.org>
 <20090224231154.60ba18d6@i1501.lan.towertech.it> <1235514727.18632.93.camel@macbook.infradead.org> <alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be> <20090225111836.621412c1@i1501.lan.towertech.it>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Alessandro Zummo wrote:

> > I didn't know NTP was broken with RTC class drivers?
> > 
> > So we should actually keep on using genrtc instead of rtc-ppc/rtc-generic for
> > now? ;-)
> 
>  broken here means that the kernel won't save the time to the hardware
>  rtc every 11 minutes as it used to do. normal NTP operations are unaffected.

 I posted patches to support it last year -- from your answer I infer they 
were not applied in the end.  I'll see if I can try to refresh them and 
push again next time I'll be upgrading my kernel.

  Maciej
