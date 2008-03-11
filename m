Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYCKAk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYCKAk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYCKAkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:40:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50347 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYCKAkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:40:14 -0400
Message-ID: <47D5D4E7.1060900@garzik.org>
Date: Mon, 10 Mar 2008 20:40:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl>
In-Reply-To: <200803110014.52985.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9992
> Subject		: 2.6.24-git: kmap_atomic() WARN_ON()
> Submitter	: Thomas Gleixner <tglx@linutronix.de>
> Date		: 2008-02-07 00:58
> References	: http://lkml.org/lkml/2008/2/6/451
> 		  http://lkml.org/lkml/2007/1/14/38

Solved by b445c56815d84b9fce40707f99811bdc354458e0


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
> Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date		:  Tue May 22 22:47:54 2007 -0400
> References	: http://lkml.org/lkml/2008/3/10/340
> Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> Patch		: http://lkml.org/lkml/2008/3/10/91

FWIW, I have this same problem.

