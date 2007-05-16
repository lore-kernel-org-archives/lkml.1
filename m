Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbXEPHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbXEPHEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXEPHEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:04:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33895 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbXEPHEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:04:45 -0400
Date: Wed, 16 May 2007 09:03:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <20070515212700.b400e8db.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0705160903130.9570@yvahk01.tjqt.qr>
References: <20070516031315.132DFDBA1@gherkin.frus.com>
 <20070515212700.b400e8db.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 21:27, Randy Dunlap wrote:
>On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
>
>> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
>> It panics early enough that some of what I'm sure would be useful has
>> already scrolled off the screen, and there's no scrollback buffer at
>> that point.  If more detail is needed, I'll have to transcribe what I
>> *can* see by hand.
>
>or use digital camera photo of screen if you have such a camera.
>
>It's a good idea to increase the screen virtual size by decreasing
>the font size if your video driver supports that.

In short, boot with vga=6 (80x50), or even vga=ask, selecting something with
lots of chars (132x60 for example)


	Jan
-- 
