Return-Path: <linux-kernel-owner+w=401wt.eu-S1946176AbXBPSJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946176AbXBPSJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946179AbXBPSJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:09:39 -0500
Received: from beta2.look.ca ([207.136.100.3]:55079 "EHLO twiddle.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946176AbXBPSJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:09:39 -0500
Date: Fri, 16 Feb 2007 13:10:27 -0500
To: Daniel Walker <dwalker@mvista.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20070216181027.GC6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <1171647921.3422.12.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1171647921.3422.12.camel@imap.mvista.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 09:45:21AM -0800, Daniel Walker wrote:
> I've been working on a patch set (below), to expose the clocksources
> used by generic time to multiple users . It would allow timestamps from
> different clocks in a generic way. It's not merged, but I'd appreciate
> any input either of you might have..
> 
> ftp://source.mvista.com/pub/dwalker/clocksource/

Is it possible to see the resulting clocksource.h and maybe
clocksource.c after the patch set? That would make looking at it much
easier.

-Jeff
