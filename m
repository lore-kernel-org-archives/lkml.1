Return-Path: <linux-kernel-owner+w=401wt.eu-S1161333AbXDWKvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333AbXDWKvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161339AbXDWKvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:51:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45835 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161333AbXDWKvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:51:01 -0400
Date: Mon, 23 Apr 2007 12:50:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-ID: <20070423105053.GD5635@elf.ucw.cz>
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222139.27128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222139.27128.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move all of the freezer-related flags to a separate field in task_struct and
> introduce functions to operate them using set_bit() etc.

Looks sane to me.

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
