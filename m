Return-Path: <linux-kernel-owner+w=401wt.eu-S1764481AbYETAtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764481AbYETAtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYETAtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:49:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYETAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:49:02 -0400
Date: Mon, 19 May 2008 20:49:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Kasper Sandberg <lkml@metanurb.dk>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt2
In-Reply-To: <1211242757.19845.48.camel@localhost>
Message-ID: <Pine.LNX.4.58.0805192048330.4125@gandalf.stny.rr.com>
References: <1211237032.14697.76.camel@localhost.localdomain>
 <1211242757.19845.48.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Kasper Sandberg wrote:

> On Mon, 2008-05-19 at 18:43 -0400, Steven Rostedt wrote:
> > We are pleased to announce the 2.6.25.4-rt2 tree, which can be
> <snip>
>
> I have just tested this, and it breaks jackd horribly, no matter the
> settings, jack ALWAYS underruns.
>
> What information do you need me to provide?

Also, could you try 2.6.24.7-rt7.

Thanks,

-- Steve

