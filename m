Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbXHNSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbXHNSYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXHNSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:24:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXHNSYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:24:02 -0400
Date: Tue, 14 Aug 2007 11:22:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
 Suspend, aka swsusp):
Message-Id: <20070814112237.a5f1e1a4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	<200708132338.25925.rjw@sisk.pl>
	<20070814070528.GA2903@elf.ucw.cz>
	<200708141937.06676.rjw@sisk.pl>
	<1187114231.32555.105.camel@localhost>
	<alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 11:15:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words, it would be much better to just have per-file markers, 
> along with some per-subdirectory stuff or similar.

And a `make maintainers' target to pull it all together..

(perhaps we could add a

	maintainer <keyword>

record to Kconfig, then `make maintainers' goes and looks up <keyword>
somewhere and does something with it)
