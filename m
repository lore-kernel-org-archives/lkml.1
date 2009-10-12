Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZJLIKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZJLIKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZJLIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:10:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:20306 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZJLIKe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:2>);
	Mon, 12 Oct 2009 04:10:34 -0400
Message-Id: <4AD30073020000780001938F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 12 Oct 2009 09:09:55 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #14279] Suspend to RAM freeze totally since
	 2.6.32-rc1 - Acer Aspire 1511Lmi laptop
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
 <r-4Wjt4coy.A.WZE.Abl0KB@chimera>
In-Reply-To: <r-4Wjt4coy.A.WZE.Abl0KB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue is still present, albeit a patch (available in the bugzilla entry) had
been posted on Oct 6th. Jan

>>> "Rafael J. Wysocki" <rjw@sisk.pl> 12.10.09 00:22 >>>
This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14279 
Subject		: Suspend to RAM freeze totally since 2.6.32-rc1 - Acer Aspire 1511Lmi laptop
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:14 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5f68563996e812f9ca35b3939ad2a42e5d254d66 



