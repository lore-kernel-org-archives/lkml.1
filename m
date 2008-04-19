Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYDSB64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYDSB64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYDSB6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYDSB6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:58:48 -0400
Date: Fri, 18 Apr 2008 18:58:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: simplify hex print
Message-Id: <20080418185812.1e4a4b66.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 14:33:20 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:

> +static const char hex2asc[] = "0123456789abcdef";

43.
