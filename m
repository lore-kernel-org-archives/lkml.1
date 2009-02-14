Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZBNXcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZBNXcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZBNX3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:29:17 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:35368 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757844AbZBNX3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:29:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYHAF/hlklMQWt2/2dsb2JhbACBbIEwzheEHAY
Date: Sat, 14 Feb 2009 18:29:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12660] Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad
	T43p
Message-ID: <20090214232911.GA19127@Krystal>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.6SE.or0lJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <rjPbZ5GRJPO.A.6SE.or0lJB@chimera>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:28:33 up 44 days, 23:26,  4 users,  load average: 1.04, 0.59,
	0.49
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12660
> Subject		: Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad T43p
> Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date		: 2009-02-04 21:11 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=123378196022258&w=4
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> 

Yes, still applies to 2.6.28.4 and 2.6.28.5.

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
