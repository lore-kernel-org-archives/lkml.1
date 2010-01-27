Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917Ab0A0R77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0A0R77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876Ab0A0R76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:59:58 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:34688 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755353Ab0A0R75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:59:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QEcc9YMTedtSxCLVs1AalA5C09SnlPNhkGfu2FNtnQsz7BtYljH+hhmbtA3yrmRpPendUmUZgmamm9vCdRl3fQC1A5sRHDWzTpsblHMXyG8SymFo51QWuTKOOh/s0ASu;
Date: Wed, 27 Jan 2010 09:59:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "Thomas Meyer" <thomas@m3y3r.de>
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes the
 screen flicker
Message-ID: <20100127095940.07e205ba@jbarnes-piketon>
In-Reply-To: <q60Z28d_9yH.A.fTB.-aMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A.fTB.-aMXLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 23:22:54 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
> Subject		: i915: playing video via XVideo extension makes the screen flicker
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2009-11-23 13:15 (63 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b42d4c5c6a872815d711e5d51a600f5122c38eee
> References	: http://lkml.org/lkml/2010/1/11/150
> 

this one may also be fixed by David's patch if -rc5 doesn't already fix
it.

-- 
Jesse Barnes, Intel Open Source Technology Center
