Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYHXVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYHXVh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYHXVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:37:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYHXVhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:37:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Date: Sun, 24 Aug 2008 23:40:31 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242340.31988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 23 of August 2008, Rafael J. Wysocki wrote:
[--snip--]

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11361
> Subject		: my servers with nvidia mcp55 nic don't work with msi in second kernel by kexec
> Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
> Date		: 2008-08-17 6:25 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=121895439927053&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://marc.info/?l=linux-kernel&m=121917167232014&w=4

[--snip--]
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
> Subject		: net: forcedeth call restore mac addr in nv_shutdown path
> Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
> Date		: 2008-08-17 3:30 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4

Jeff, do you have the patches for these two in your queue?

Rafael
