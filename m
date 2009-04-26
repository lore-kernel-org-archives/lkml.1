Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZDZSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZDZSc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZDZScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 14:32:09 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:33975 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbZDZScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 14:32:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEFAJBE9ElMQW1W/2dsb2JhbACBUMk2gjaBPgU
Date: Sun, 26 Apr 2009 14:32:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, stable@kernel.org
Subject: Re: [Bug #13186] cpufreq timer teardown problem
Message-ID: <20090426183205.GA29238@Krystal>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.X-B._oE9JB@chimera> <20090426162800.GB25774@Krystal> <200904261945.11690.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200904261945.11690.rjw@sisk.pl>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:30:21 up 57 days, 14:56,  1 user,  load average: 0.22, 0.31,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Sunday 26 April 2009, Mathieu Desnoyers wrote:
> > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.28 and 2.6.29.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > 
> > I've had no news that the patches I proposed has been considered for
> > -stable. They fix the teardown problem here. So I guess it's better to
> > wait for the patches to get into -stable before we close this bug ?
> 
> In fact the bug is closeable as soon as they are in the Linus' tree.  Are they
> in it right now?
> 

Nope, Andrew pulled the conservative governor fix for 2.6.30-rc in his
tree, but that's about it.

The fixes for ondemand 2.6.28, 2.6.29 and 2.6.30-rc have not been pulled
yet. The fix for conservative 2.6.28, 2.6.29 has not been pulled
neither.

Mathieu

> Thanks,
> Rafael

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
