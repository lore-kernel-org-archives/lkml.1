Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZJZTEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZJZTEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZJZTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:04:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZJZTEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Len Brown" <len.brown@intel.com>, "Lin Ming" <ming.m.lin@intel.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.Z4G.kre5KB@chimera>
Subject: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-08 21:46 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347


