Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXISLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXISLpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXISLpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:45:23 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:46723 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239AbXISLpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:45:22 -0400
Date: Wed, 19 Sep 2007 07:45:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Michael Boerner <michael@boernerconsulting.com>
Subject: Re: [PATCH] Combine instrumentation menus in kernel/Kconfig.instrumentation
Message-ID: <20070919114516.GH15500@Krystal>
References: <20070918211259.GA14927@Krystal> <14754.1190151939@turing-police.cc.vt.edu> <20070919010627.GA24174@Krystal> <3956.1190181478@turing-police.cc.vt.edu> <20070919112033.GF15500@Krystal> <Pine.LNX.4.64.0709190731570.16870@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709190731570.16870@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:38:34 up 51 days, 11:57,  4 users,  load average: 2.03, 1.89, 1.60
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert P. J. Day (rpjday@mindspring.com) wrote:
> On Wed, 19 Sep 2007, Mathieu Desnoyers wrote:
> 
> > * Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> 
> > > Ahh, LTT. *that* I recognize.  Yeah, I count that as *one flavor*
> > > of instrumentation. :)
> 
> mathieu clarified this in a previous email to me, but is LTT not
> entirely superseded by LTT-ng?  just curious.
> 

Yes, LTTng supersedes LTT. It provides the ability to extract traces
across execution layers (hypervisor, kernel, userspace) to perform
performance analysis and debugging of applications at the system level.
LTTng's approach differs from LTT in that it allows completely
customizable instrumentation. We chose to provide that based on the
previous LTT experience, where we have seen that adding instrumentation
is very often required when digging deeply into a problem.

Mathieu

> rday
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://crashcourse.ca
> ========================================================================

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
