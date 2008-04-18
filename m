Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYDRG2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYDRG2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYDRG2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:28:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbYDRG2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:28:08 -0400
Date: Thu, 17 Apr 2008 23:27:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417232747.4c04f413.akpm@linux-foundation.org>
In-Reply-To: <20080416202338.GA6007@elte.hu>
References: <20080416202338.GA6007@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> Arjan van de Ven (6):
>	...
>       x86: mark init_mm deprecated

Why can't I find this patch on the mailing list?

It's an MM patch which touches sched.h.  It should not be in git-x86.

It generates over a megabyte of warnings on sparc64.
