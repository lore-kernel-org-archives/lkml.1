Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZGVPRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZGVPRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGVPRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:17:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZGVPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:17:13 -0400
Date: Wed, 22 Jul 2009 11:17:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Johannes Berg <johannes@sipsolutions.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: binary ftrace buffer format
In-Reply-To: <1248262609.10231.0.camel@johannes.local>
Message-ID: <alpine.DEB.2.00.0907221116310.1059@gandalf.stny.rr.com>
References: <1247520189.4071.4.camel@johannes.local>  <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com> <1248262609.10231.0.camel@johannes.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Johannes Berg wrote:

> On Mon, 2009-07-20 at 21:51 -0400, Steven Rostedt wrote:
> 
> > You can get the tool here:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> Another thing that just crossed my mind -- is this a candidate for
> tools/ maybe?

Actually, I'm looking at putting this into perf. That way we have one tool 
with one format. I'll have to work with Ingo to see exactly how this 
should be done.

-- Steve

