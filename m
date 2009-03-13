Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZCMALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZCMALz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZCMALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:11:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZCMALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:11:46 -0400
Date: Thu, 12 Mar 2009 20:11:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jason Baron <jbaron@redhat.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org,
       compudj@krystal.dyndns.org
Subject: Re: [Patch 0/2] tracepoints for softirq entry/exit
In-Reply-To: <20090312182950.GA3352@redhat.com>
Message-ID: <alpine.DEB.2.00.0903122011220.9869@gandalf.stny.rr.com>
References: <20090312182950.GA3352@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Jason Baron wrote:

> hi,
> 
> Somewhat analogous to the hard irq entry/exit tracepoints. This patch
> series introduces tracepoints for softirq entry/exit points.
> 
> These tracepoints are useful for augmenting the various tracers (sample
> output below), and for understanding frequencies and timings for
> softirqs. Very similar tracepoints are also in Mathieu's lttng tree.
> 
> thanks,

Applied, thanks!

-- Steve

