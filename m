Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZHZARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZHZARc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZHZARb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:17:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541AbZHZARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:17:30 -0400
Date: Tue, 25 Aug 2009 17:16:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #14030] Kernel NULL pointer dereference at 0000000000000008,
 pty-related
In-Reply-To: <_yaHeGjHEzG.A.D2G.3sGlKB@chimera>
Message-ID: <alpine.LFD.2.01.0908251716050.3218@localhost.localdomain>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.D2G.3sGlKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14030
> Subject		: Kernel NULL pointer dereference at 0000000000000008, pty-related
> Submitter	: Eric W. Biederman <ebiederm@xmission.com>
> Date		: 2009-08-20 5:46 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=125074724623423&w=4
> Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> Patch		: http://patchwork.kernel.org/patch/43679/

This is now committed as 5c58ceff103d8a654f24769bb1baaf84a841b0cc. 

		Linus

