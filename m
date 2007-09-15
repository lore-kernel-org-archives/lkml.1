Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXIOJfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXIOJfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXIOJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:35:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbXIOJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:35:12 -0400
Date: Sat, 15 Sep 2007 02:32:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-Id: <20070915023258.cb5b8048.akpm@linux-foundation.org>
In-Reply-To: <20070911211422.GU3563@stusta.de>
References: <20070911201219.GA9674@uranus.ravnborg.org>
	<200709112138.11247.ak@suse.de>
	<20070911211422.GU3563@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 23:14:22 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> People do not expect code under arch/i386/ to be used by code under 
> arch/x86_64/ and vice versa.

[OT: it drives me batshit that we ended up including stuff in both directions]
