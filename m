Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZBPS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZBPS0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZBPS0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:26:33 -0500
Received: from newton.gmurray.org.uk ([81.2.114.237]:53445 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZBPS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:26:32 -0500
X-Greylist: delayed 2036 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 13:26:32 EST
X-DKIM: Sendmail DKIM Filter v2.8.1 newton.gmurray.org.uk n1GHqZhO011321
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #12444] X hangs following switch from radeonfb console - Bisected
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
	<rjPbZ5GRJPO.A._pG.Lt0lJB@chimera>
X-Hashcash: 1:22:090216:linux-kernel@vger.kernel.org::UTzct0umASMcaQ2N:000000000000000000000000000000000Z5Lp
Date: Mon, 16 Feb 2009 17:52:34 +0000
In-Reply-To: <rjPbZ5GRJPO.A._pG.Lt0lJB@chimera> (Rafael J. Wysocki's message
	of "Sat, 14 Feb 2009 21:38:15 +0100 (CET)")
Message-ID: <87k57quv4t.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.90 (gnu/linux)
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
> Date		: 2009-01-13 14:03 (33 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a

I am still seeing the problem with 2.6.29-rc5
