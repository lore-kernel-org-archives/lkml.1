Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbZCOKI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbZCOKI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZCOKIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:08:17 -0400
Received: from newton.gmurray.org.uk ([81.2.114.237]:33574 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZCOKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:08:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 newton.gmurray.org.uk n2FA8Dkg007519
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #12444] X hangs following switch from radeonfb console - Bisected
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	<GCLaknAim2M.A.NXF.F7BvJB@chimera>
X-Hashcash: 1:22:090315:linux-kernel@vger.kernel.org::WlBHr/Bh3qXa4xoq:000000000000000000000000000000000QBfP
Date: Sun, 15 Mar 2009 10:08:13 +0000
In-Reply-To: <GCLaknAim2M.A.NXF.F7BvJB@chimera> (Rafael J. Wysocki's message
	of "Sat, 14 Mar 2009 20:05:28 +0100 (CET)")
Message-ID: <87wsardroy.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am no longer seeing this problem with 2.6.29-rc8-00090g326d851, but I
have also upgrade various parts of X including the radeon driver to
version 6.12.0. 

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
> Date		: 2009-01-13 14:03 (61 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
