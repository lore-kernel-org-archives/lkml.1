Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbXBVWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbXBVWVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXBVWVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:21:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41063 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXBVWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:21:52 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Arjan van de Ven <arjan@infradead.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: tglx@linutronix.de, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45DE0607.2090601@drzeus.cx>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	 <1172150712.3531.265.camel@laptopd505.fenrus.org>
	 <45DDA43A.4030509@drzeus.cx>
	 <1172154034.3531.270.camel@laptopd505.fenrus.org>
	 <45DDADEB.3030309@drzeus.cx>  <45DDB31C.8070306@drzeus.cx>
	 <1172160024.25076.188.camel@localhost.localdomain>
	 <45DDC488.1080008@drzeus.cx>
	 <1172162526.3531.275.camel@laptopd505.fenrus.org>
	 <45DE0607.2090601@drzeus.cx>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 23:21:44 +0100
Message-Id: <1172182904.3265.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 22:07 +0100, Pierre Ossman wrote:
> Arjan van de Ven wrote:
> > no; c3 saves a TON more power. 
> >
> > you can try enabling HPET in your BIOS...
> >
> >   
> 
> Hah, I wish! This is a laptop, so the BIOS is as brain dead and broken
> as is humanly possible.
> 
> Can I determine if I have the required hardware? So I can tell if I'm
> permanently screwed, or just temporarily.

if it's something built in the last year or two you have the hw.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

