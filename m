Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXBWNMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXBWNMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbXBWNMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:12:51 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:37394 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbXBWNMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:12:50 -0500
Date: Fri, 23 Feb 2007 14:11:50 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
In-Reply-To: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
Message-ID: <Pine.LNX.4.61.0702231411130.9736@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23 2007 06:41, Justin Piszcz wrote:
>
> I was able to Alt-SysRQ+b but I could not access the console/X/etc, it appeared
> to be frozen.

No sysrq+t? (Ah, unblanking might hang.) Well, netconsole/serial to the rescue,
then ;-)


Jan
-- 
