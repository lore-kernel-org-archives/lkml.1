Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZCLNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZCLNOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZCLNOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:14:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZCLNOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:14:38 -0400
Date: Thu, 12 Mar 2009 09:12:46 -0400
From: Neil Horman <nhorman@redhat.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
	tip/tracing/ftrace
Message-ID: <20090312131246.GA6871@shamino.rdu.redhat.com>
References: <20090312023720.144716747@goodmis.org> <20090312080758.4a14d5b4@mjolnir.ossman.eu> <20090312104721.GA6005@shamino.rdu.redhat.com> <20090312131207.1c7fa213@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312131207.1c7fa213@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:12:07PM +0100, Pierre Ossman wrote:
> On Thu, 12 Mar 2009 06:47:21 -0400
> Neil Horman <nhorman@redhat.com> wrote:
> 
> > On Thu, Mar 12, 2009 at 08:07:58AM +0100, Pierre Ossman wrote:
> > > 
> > > How difficult is it to apply this to 2.6.27? Fedora is still on that
> > > kernel and it would be nice if I could get my memory back on a
> > > distribution kernel. :)
> > 
> > I'm looking into it currently.  I'll post a test kernel when I have something
> > for you.
> 
> F9 kernel if possible, as that's what the test machine is running.
> 
I doubt I'll get an update into F9, given that it will go end of life soon, but
I'll try
Neil

> Rgds
> -- 
>      -- Pierre Ossman
> 
>   WARNING: This correspondence is being monitored by the
>   Swedish government. Make sure your server uses encryption
>   for SMTP traffic and consider using PGP for end-to-end
>   encryption.


