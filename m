Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYGDCVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYGDCVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYGDCUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:20:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbYGDCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:20:54 -0400
Date: Thu, 3 Jul 2008 22:20:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linuxfoundation.org,
       peterz@infradead.org, stable@kernel.org
Subject: Re: [PATCH] hrtimer: prevent migration for raising softirq
In-Reply-To: <20080703190306.d2c7edd5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0807032219450.7798@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807031428440.7798@gandalf.stny.rr.com>
 <20080703155302.5f86d8f4.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0807032148340.7798@gandalf.stny.rr.com>
 <20080703190306.d2c7edd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 3 Jul 2008, Andrew Morton wrote:
> >
> > [/me goes to look at the 2.6.25.4 he has sitting around]
> >
> > The above mentioned commit (Title: hrtimer: raise softirq unlocked to
> > avoid circular lock dependency) is, in fact, in 2.6.25.4.
> >
>
> Ah, OK, I'm a dope.
>

No, you're not. Overworked, perhaps, but definitely not a dope ;-)

-- Steve

