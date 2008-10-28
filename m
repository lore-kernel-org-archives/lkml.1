Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYJ1Pp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYJ1Pp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYJ1Ppu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:45:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ1Ppu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:45:50 -0400
Date: Tue, 28 Oct 2008 11:41:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
In-Reply-To: <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>  <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>  <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>  <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
  <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com> <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:
> 
> An that corrects the bug when I failed to assign the sched_switch tracer.
> Thanks Steven!
> 
> Tested-by: Frederic Weisbecker <fweisbec@gmail.com>

Do you still have issues with the function tracer in the latest linux-tip?
If so, can you rebuild it from scratch, send me the config again, and 
explain in detail what the issue is.

Thanks,

-- Steve

