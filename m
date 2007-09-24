Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXIXV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXIXV3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbXIXV3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:29:14 -0400
Received: from www.osadl.org ([213.239.205.134]:33983 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755812AbXIXV3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:29:13 -0400
Subject: Re: x86-64 sporadic hang in  2.6.23rc7 and 2.6.22
From: Thomas Gleixner <tglx@linutronix.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46F8273B.8030904@aitel.hist.no>
References: <46F8273B.8030904@aitel.hist.no>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 23:29:11 +0200
Message-Id: <1190669351.4035.254.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 23:08 +0200, Helge Hafting wrote:
> The two kernels mentioned hangs occationally.
> Typically when I compile something and pass the time
> by surfing the web.
> 
> A few minutes and then I notice that the mouse (and everything else in X)
> stops.  kbd LEDs does not react to numlock/capslock.
> The only thing that still works is sysrq+B
> So far this has happened while running X, so no messages.
> 
> I have gone back to 2.6.22rc4, which seems to work.
> 
> This is a single opteron, although on a dual-slot board.

Can you switch to serial console, so we can get some information out of
that box? Sysrq-B is working, so we can get info from other sysrq
functions as well.

	tglx


