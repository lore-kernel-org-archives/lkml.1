Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXCZIzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXCZIzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXCZIzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:55:05 -0400
Received: from www.osadl.org ([213.239.205.134]:34087 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932167AbXCZIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:55:03 -0400
Subject: Re: Linux 2.6.21-rc5
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 10:55:00 +0200
Message-Id: <1174899300.4182.8.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 16:08 -0700, Linus Torvalds wrote:
> Those timer changes ended up much more painful than anybody wished for, 
> but big thanks to Thomas Gleixner for being on it like a weasel on a dead 
> rat, and the regression list has kept shrinking.

Why certainly ! I caused them, so I have to fix them. There are still a
few to hunt down and I want to sort them out before 2.6.21 final.

> So if you have reported a regression in the 2.6.21-rc series, please check 
> 2.6.21-rc5, and update your report as appropriate (whether fixed or "still 
> problems with xyzzy").

This fix from John Stultz is still missing:

http://lkml.org/lkml/2007/3/22/287

It's in Andrews queue already and waits to be sent to you.

	tglx



