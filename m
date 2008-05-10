Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYEJBqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYEJBqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 21:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYEJBpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 21:45:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61151 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750735AbYEJBps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 21:45:48 -0400
Date: Sat, 10 May 2008 02:43:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080509223845.4a38d751@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805100236410.10552@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507085953.2c08b854@hyperion.delvare> <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
 <20080508105905.3209c659@hyperion.delvare> <Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
 <20080509092835.3bbf0f55@hyperion.delvare> <Pine.LNX.4.55.0805092054030.10552@cliff.in.clinika.pl>
 <20080509223845.4a38d751@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> I agree, i2c-sibyte is very old code, and unmaintained, coding style is
> horrible. That's one more reason to not include random style cleanups
> in a patch doing functional changes, the improvement will hardly be
> visible. If you care about cleaning up the code of this driver - and I
> would appreciate that - please make a separate patch.

 While I have not officially undertaken maintenance of code to support any
of the pieces of hardware relevant to the SWARM board, I have done a
considerable number of changes throughout all the bits and if you have any
concern related to this piece of code (or any other I am referring to
here), then you are certainly welcome to contact me directly, cc-ing
linux-mips, perhaps.  I do SWARM development solely in my free time and I
simply cannot afford chasing all the bits around, especially ones I do not
actively use.  I do try to care about bits other people have concerns
about though.

  Maciej
