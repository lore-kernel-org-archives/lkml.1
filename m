Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZJLNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZJLNQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZJLNQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:16:29 -0400
Received: from bu3sch.de ([62.75.166.246]:50409 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbZJLNQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:16:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14278] New message "NOHZ: local_softirq_pending 08" at each ping request
Date: Mon, 12 Oct 2009 15:15:47 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "John W. Linville" <linville@tuxdriver.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <r-4Wjt4coy.A.VeE.Bbl0KB@chimera>
In-Reply-To: <r-4Wjt4coy.A.VeE.Bbl0KB@chimera>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121515.49393.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009 00:22:00 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14278
> Subject		: New message "NOHZ: local_softirq_pending 08" at each ping request
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2009-09-30 18:12 (12 days old)
> Handled-By	: Michael Buesch <mb@bu3sch.de>

I think John or Johannes is handling it, as my patch was rejected.

> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23220

-- 
Greetings, Michael.
