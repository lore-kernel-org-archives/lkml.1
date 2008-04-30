Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYD3UPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYD3UPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763787AbYD3UPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:15:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbYD3UPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:15:42 -0400
Date: Wed, 30 Apr 2008 13:15:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430131537.1f7a0914.akpm@linux-foundation.org>
In-Reply-To: <200804302136.58005.rjw@sisk.pl>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 21:36:57 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> IMO, the merge window is way too short for actually testing anything.

<jumps up and down>

There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!

_anything_ which appears in 2.6.x-rc1 and which wasn't in 2.6.x-mm1 was
snuck in too late (OK, apart from trivia and bugfixes).


If we decide that we need to fix the oh-shit-lets-slam-this-in-and-hope
problem then I expect we can do so, via fairly relible means.

But the first attempt at solving it should be to ask people to not do that.
