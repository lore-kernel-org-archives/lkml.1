Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZJKXHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZJKXHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZJKXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:07:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbZJKXGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Patterson" <andrew.patterson@hp.com>,
       "David Woodhouse" <David.Woodhouse@intel.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.F2B.azl0KB@chimera>
Subject: [Bug #14309] MCA on hp rx8640
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14309
Subject		: MCA on hp rx8640
Submitter	: Andrew Patterson <andrew.patterson@hp.com>
Date		: 2009-09-29 17:20 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
References	: http://www.spinics.net/lists/linux-usb/msg22799.html


