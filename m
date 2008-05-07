Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbYEGUG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbYEGUG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbYEGUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:06:44 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63259 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756676AbYEGUGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:06:42 -0400
Date: Wed, 7 May 2008 21:03:31 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
cc: rtc-linux@googlegroups.com, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [RFC][PATCH 0/4] RTC: Use class devices as a persistent
 clock
In-Reply-To: <20080507085739.4f538d2e@i1501.lan.towertech.it>
Message-ID: <Pine.LNX.4.55.0805072055010.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805062333390.16173@cliff.in.clinika.pl>
 <20080507085739.4f538d2e@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

>    you did a great work. you have my Acked-by on the rtc/ntp code, but
>  I think we'd need some reports from current users of the m41t81 driver
>  before pushing that one in.

 Thanks for appreciation.  You are right about the driver -- I have
explicitly asked for help to test it with the patch submission.  Actually
the only other user right now is a D-Link DNS-323 ARM-based system.  I
meant to cc the maintainer of the platform, but in the end I forgot.  
I'll do it now -- thanks for the point.

  Maciej
