Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXD1Us5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXD1Us5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXD1Us5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:48:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43930 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756086AbXD1Usz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:48:55 -0400
Date: Sat, 28 Apr 2007 22:48:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags (rev. 2)
Message-ID: <20070428204830.GC3389@elf.ucw.cz>
References: <200704281135.56275.linux-kernel-owner@vger.kernel.org> <200704281140.22474.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704281140.22474.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-04-28 11:40:21, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move all of the freezer-related flags to a separate field in task_struct and
> introduce functions to operate them using set_bit() etc.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
