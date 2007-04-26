Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXDZGf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXDZGf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXDZGf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:35:28 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45752 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030AbXDZGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:35:26 -0400
Message-ID: <4630486C.4020900@drzeus.cx>
Date: Thu, 26 Apr 2007 08:36:28 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Sergey Yanovich <ynvich@gmail.com>
CC: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <4627D402.8020107@gmail.com>
In-Reply-To: <4627D402.8020107@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Yanovich wrote:
> 
> I have found it easier to rewrite the driver, than to fix.

Before you get your hopes up, this development model is not one that will get
your code merged upstream. You should really try to work with Alex, not side
step him. Drivers are rarely complex enough to warrant, or even have room for, a
rewrite. And judging from your code it looks more like reorganising the code
that's already there.

In short, this "rewrite" won't fly. Report the issues you have with the current
driver and work with the existing maintainer to get them fixed.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
