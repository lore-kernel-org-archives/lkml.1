Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYBZFZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYBZFZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYBZFZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:25:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43590 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYBZFZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:25:24 -0500
Date: Mon, 25 Feb 2008 21:22:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Dave Young" <hidave.darkstar@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: "Dave Jones" <davej@codemonkey.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: boot_delay broken ?
Message-Id: <20080225212251.18c4659e.randy.dunlap@oracle.com>
In-Reply-To: <a8e1da0802241814x48e169f2v82823c55412fc534@mail.gmail.com>
References: <20080224004615.GA31012@codemonkey.org.uk>
	<a8e1da0802241814x48e169f2v82823c55412fc534@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 10:14:36 +0800 Dave Young wrote:

> On Sun, Feb 24, 2008 at 8:46 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
> > The boot_delay switch seems to be behaving strangely in the
> >  current -git.  Setting it to =10 makes the output 'bursty'
> >  it becomes slow for some printk's whilst others scroll by
> >  at regular speed.
> >  Setting it any higher than that seems to make it pause for
> >  a really long time before it outputs any text at all.
> 
> On my side there's this issue for a long time
> http://lkml.org/lkml/2007/8/8/79

[http://marc.info/?l=linux-kernel&m=118655896515049&w=2]

You asked questions and they were answered.  Perhaps you didn't like
the answers.

Here's a question for you.  What kernel boot options did you use?
Specifically, for lpj= and boot_delay= ?

> >
> >  x86 timer changes perhaps ?


---
~Randy
