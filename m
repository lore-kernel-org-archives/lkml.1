Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZBDNzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZBDNzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZBDNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:55:07 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48512 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZBDNzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:55:06 -0500
Date: Wed, 4 Feb 2009 14:54:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew S. Johnson" <andy@asjohnson.com>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
In-Reply-To: <CGyEB0S4BpO.A.BkB.g5YiJB@chimera>
Message-ID: <alpine.LRH.1.10.0902041453190.22097@twin.jikos.cz>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.BkB.g5YiJB@chimera>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> Subject		: TMDC Joystick no longer works in kernel 2.6.28
> Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> Date		: 2009-01-10 21:53 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=123162486415366&w=4

I asked [1] the Submitter some time ago to check whether reverting a 
particular commit fixes the issue, but never heard back.

[1] http://lkml.org/lkml/2009/1/26/70

-- 
Jiri Kosina
SUSE Labs

