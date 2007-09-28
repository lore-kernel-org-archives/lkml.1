Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXI1QZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXI1QZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXI1QYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:24:49 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:34122 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbXI1QYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:24:48 -0400
Date: Fri, 28 Sep 2007 12:24:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] Add samples subdir
Message-ID: <20070928162446.GA13051@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.638289605@polymtl.ca> <46FD21F8.9030202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46FD21F8.9030202@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:24:35 up 60 days, 16:43,  4 users,  load average: 0.28, 0.26, 0.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> Mathieu Desnoyers wrote:
> >From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >
> >Begin infrastructure for kernel code samples in the samples/ directory.
> >Add its Kconfig and Kbuild files.
> >Source its Kconfig file in all arch/ Kconfigs.
> >
> >Changelog:
> >- Move menu to Kernel Hacking
> >- Don't build with the kernel image
> >
> >Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I think that this one is S-O-B by both of us.
> 

Yes, thanks,

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> -- 
> ~Randy
> Phaedrus says that Quality is about caring.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
