Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZDZQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZDZQ2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZDZQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:28:06 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:63075 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbZDZQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:28:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAHAG8o9ElMQW1W/2dsb2JhbACBUIEwxzaCNoE+BQ
Date: Sun, 26 Apr 2009 12:28:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, stable@kernel.org
Subject: Re: [Bug #13186] cpufreq timer teardown problem
Message-ID: <20090426162800.GB25774@Krystal>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.X-B._oE9JB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <egHshlwQQFE.A.X-B._oE9JB@chimera>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:24:19 up 57 days, 12:50,  1 user,  load average: 0.17, 0.38,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 

I've had no news that the patches I proposed has been considered for
-stable. They fix the teardown problem here. So I guess it's better to
wait for the patches to get into -stable before we close this bug ?

Mathieu

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13186
> Subject		: cpufreq timer teardown problem
> Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date		: 2009-04-23 14:00 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=124049523515036&w=4
> Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Patch		: http://patchwork.kernel.org/patch/19754/
> 		  http://patchwork.kernel.org/patch/19753/
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
