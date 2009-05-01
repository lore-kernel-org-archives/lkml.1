Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbZEAOIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbZEAOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZEAOHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:07:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZEAOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:07:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 16:07:48 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <200905011556.39437.arnd@arndb.de> <20090501150319.192f6dce@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501150319.192f6dce@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011607.49522.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+HfC1mBWvEQBC7/c7mYav5t9qiet1dsdxAmqC
 H73yoPwY/sf9v6FlgsDUPbDDa8/FSRLSID8HWN4kvdZ5ew4fBe
 wP1bl/lOsyTmnatSS03Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Alan Cox wrote:
> So we now have at least two conflicting meanings for CLOCK_TICK_RATE
> which again says it needs fixing not wallpapering over.

Right, I agree. I'll look into it next week.

	Arnd <><
