Return-Path: <linux-kernel-owner+w=401wt.eu-S1031185AbXDSHdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031185AbXDSHdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031192AbXDSHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:33:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55887 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031161AbXDSHdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:33:04 -0400
Date: Thu, 19 Apr 2007 09:32:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: david rankin <drankinatty@suddenlinkmail.com>
cc: kernel <linux-kernel@vger.kernel.org>
Subject: Re: built 2.6.20.7 on suse 10.0, boots fine, no mouse, network or
 keyboard
In-Reply-To: <001601c781d0$9c424d40$6207a8c0@rankinp35>
Message-ID: <Pine.LNX.4.61.0704190930040.30549@yvahk01.tjqt.qr>
References: <001601c781d0$9c424d40$6207a8c0@rankinp35>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 18 2007 10:45, david rankin wrote:
>
> Mates,
>
>   First post and I am having heck building the vanilla 2.6.20.7 kernel on
> Suse 10.0. Basically I put 2.6.20.7 in /usr/src, then I did
>[...]
>   All current minimal requierments are met *except* udev which is version
> 068. Everything compiled and installed properly and initrd did what it was
> supposed to:

Minimum requirement is something like udev >= 081.


Jan
-- 
