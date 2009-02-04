Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZBDSKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZBDSKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZBDSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:09:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZBDSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:09:51 -0500
Message-ID: <4989D9C3.7060408@redhat.com>
Date: Wed, 04 Feb 2009 12:09:07 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: [Bug #12602] CRED changes causing setuid failures
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.lpE.3uYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.lpE.3uYiJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12602
> Subject		: CRED changes causing setuid failures
> Submitter	: David Smith <dsmith@redhat.com>
> Date		: 2009-01-29 21:35 (7 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d84f4f992cbd76e8f39c488cf0c5d123843923b1
> References	: http://marc.info/?l=linux-kernel&m=123326501813668&w=4

I've verified this still exists in 2.6.29-rc3.

(git describe says I'm at v2.6.29-rc3-495-gdcf6a79)

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
