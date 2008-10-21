Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYJUOmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYJUOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYJUOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:41:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYJUOl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:41:56 -0400
Date: Tue, 21 Oct 2008 10:41:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] trace: create tracers menu
In-Reply-To: <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810211041380.23141@gandalf.stny.rr.com>
References: <1224599478.22771.45.camel@twins>  <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com> <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Oct 2008, Fr?d?ric Weisbecker wrote:

> 2008/10/21 Fr?d?ric Weisbecker <fweisbec@gmail.com>:
> > 2008/10/21 Peter Zijlstra <peterz@infradead.org>:
> >> Subject: trace: create tracers menu
> >> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Date: Tue Oct 21 16:26:36 CEST 2008
> >>
> >> We seem to have plenty tracers, lets create a menu and not clutter
> >> the already cluttered debug menu more.
> 
> But...you just included the function tracer inside?

Sure, why not? The function tracer is its own tracer itself.

-- Steve

