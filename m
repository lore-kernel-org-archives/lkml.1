Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZCGW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZCGW1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZCGW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:27:13 -0500
Received: from newton.gmurray.org.uk ([81.2.114.237]:52923 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZCGW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:27:12 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 newton.gmurray.org.uk n27MR8lo001306
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #12444] X hangs following switch from radeonfb console - Bisected
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	<SLCXkuHtxAO.A.NI.mXarJB@chimera>
X-Hashcash: 1:22:090307:linux-kernel@vger.kernel.org::OJriTi2gOlX9NWIq:000000000000000000000000000000000huJ/
Date: Sat, 07 Mar 2009 22:27:08 +0000
In-Reply-To: <SLCXkuHtxAO.A.NI.mXarJB@chimera> (Rafael J. Wysocki's message of
	"Tue, 3 Mar 2009 20:25:52 +0100 (CET)")
Message-ID: <87hc2555qb.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12444
> Subject		: X hangs following switch from radeonfb console - Bisected
> Submitter	: Graham Murray <graham@gmurray.org.uk>
> Date		: 2009-01-13 14:03 (50 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a

I am still seeing the same symptoms in 2.6.29-rc7-0003-g559595a.
