Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYKZF4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYKZF4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYKZF4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:56:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYKZF4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:56:22 -0500
Date: Tue, 25 Nov 2008 21:55:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace: add cpu annotation for function graph
 tracer
Message-Id: <20081125215528.eff18969.akpm@linux-foundation.org>
In-Reply-To: <20081126054728.GD9732@elte.hu>
References: <20081126051622.134970943@goodmis.org>
	<20081126051710.339437727@goodmis.org>
	<20081125213909.d4eb3f09.akpm@linux-foundation.org>
	<20081126054728.GD9732@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 06:47:28 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 26 Nov 2008 00:16:27 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > This patch adds the annotation of 'CPU[###]' where ### is a three 
> > > digit number
> > 
> > Is this a plot to get yourself sent a 1024-way test box?
> 
> So you are suggesting to change it to 4 digit printout?

Not really.  I somehow doubt that it's economic to do your software tuning
on the 1024-way ;)

> (Is this a plot to get yourself snt a 16384-way test box? ;-)

I'd settle for 1.6384 testers.
