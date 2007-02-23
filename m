Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXBWGyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXBWGyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXBWGyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:54:55 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36308 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXBWGyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:54:54 -0500
Message-ID: <45DE8FD3.5050809@drzeus.cx>
Date: Fri, 23 Feb 2007 07:55:15 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: tglx@linutronix.de, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>	 <1172099859.25076.132.camel@localhost.localdomain>	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>	 <1172150712.3531.265.camel@laptopd505.fenrus.org>	 <45DDA43A.4030509@drzeus.cx>	 <1172154034.3531.270.camel@laptopd505.fenrus.org>	 <45DDADEB.3030309@drzeus.cx>  <45DDB31C.8070306@drzeus.cx>	 <1172160024.25076.188.camel@localhost.localdomain>	 <45DDC488.1080008@drzeus.cx>	 <1172162526.3531.275.camel@laptopd505.fenrus.org>	 <45DE0607.2090601@drzeus.cx> <1172182904.3265.7.camel@laptopd505.fenrus.org>
In-Reply-To: <1172182904.3265.7.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> if it's something built in the last year or two you have the hw.
>
>   

I have an ICH4-M, and from Intel's datasheets it looks like I got the
short straw..

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

