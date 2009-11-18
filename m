Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZKRJTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZKRJTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZKRJTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:19:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53724 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZKRJTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:19:43 -0500
Date: Wed, 18 Nov 2009 10:19:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #14296] spitz boots but suspend/resume is broken
Message-ID: <20091118091949.GA32085@atrey.karlin.mff.cuni.cz>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.oNB.uUdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.oNB.uUdALB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
> Subject		: spitz boots but suspend/resume is broken
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-09-30 12:06 (48 days old)
> References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4

this one was fixed by generic pxa fix.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
