Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYAAXEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYAAXEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYAAXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:04:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56991 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbYAAXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:04:13 -0500
Date: Wed, 2 Jan 2008 00:02:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64 (rev. 2)
Message-ID: <20080102000222.GA2404@ucw.cz>
References: <200712302313.52483.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712302313.52483.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-30 23:13:51, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Document the fact that __save_processor_state() has to save all CPU
> registers referred to by the kernel in case a different kernel is
> used to load and restore a hibernation image containing it. 
> 
> Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
