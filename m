Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYJUOln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYJUOln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYJUOlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:41:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:50994 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYJUOlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:41:31 -0400
Subject: Re: [PATCH] trace: create tracers menu
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
References: <1224599478.22771.45.camel@twins>
	 <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com>
	 <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Oct 2008 16:41:22 +0200
Message-Id: <1224600082.22771.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 16:37 +0200, Frédéric Weisbecker wrote:
> 2008/10/21 Frédéric Weisbecker <fweisbec@gmail.com>:
> > 2008/10/21 Peter Zijlstra <peterz@infradead.org>:
> >> Subject: trace: create tracers menu
> >> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Date: Tue Oct 21 16:26:36 CEST 2008
> >>
> >> We seem to have plenty tracers, lets create a menu and not clutter
> >> the already cluttered debug menu more.
> 
> But...you just included the function tracer inside?

Problem being? That's a tracer too, right? And it doesn't seem required
by the other tracers (except the max stack tracer).

