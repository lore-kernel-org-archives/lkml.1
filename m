Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXIRNNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXIRNNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXIRNNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:13:36 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:35588 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbXIRNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:13:35 -0400
Date: Tue, 18 Sep 2007 09:13:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] Immediate Values - Documentation
Message-ID: <20070918131333.GB20507@Krystal>
References: <20070917184224.549435917@polymtl.ca> <20070917184321.186874558@polymtl.ca> <20070917135522.b2e0fd99.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070917135522.b2e0fd99.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:12:06 up 50 days, 13:30,  6 users,  load average: 1.03, 0.74, 0.65
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Mon, 17 Sep 2007 14:42:30 -0400 Mathieu Desnoyers wrote:
> 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > ---
> >  Documentation/immediate.txt |  228 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 228 insertions(+)
> > 
> > Index: linux-2.6-lttng/Documentation/immediate.txt
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/Documentation/immediate.txt	2007-09-17 14:03:09.000000000 -0400
> > @@ -0,0 +1,228 @@
> > +		        Using the Immediate Values
> > +
> > +			    Mathieu Desnoyers
> > +
> > +
> > +This document introduces Immediate Values and their use.
> > +
> > +* Purpose of immediate values
> > +

Updated, thanks. I also noted that I did not refresh this patch when
sending it.. a repost is needed (removed the immediate_if, which is now
gone, and changed all immediate_read(&this_immediate) for
immediate_read(this_immediate).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
