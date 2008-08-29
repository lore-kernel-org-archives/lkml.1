Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYH2Xwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYH2Xwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYH2Xwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:52:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41493 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYH2Xw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:52:29 -0400
Date: Sat, 30 Aug 2008 01:53:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: disable tracing for hibernation
Message-ID: <20080829235321.GA10523@elf.ucw.cz>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com> <200808271526.46868.rjw@sisk.pl> <200808281439.13959.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281439.13959.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-08-28 14:39:12, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ftrace: disable tracing for hibernation
>     
> In accordance with commit f42ac38c59e0a03d6da0c24a63fb211393f484b0
> ("ftrace: disable tracing for suspend to ram"), disable tracing
> around the suspend code in hibernation code paths.
>     
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks ok to me. ACK.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
