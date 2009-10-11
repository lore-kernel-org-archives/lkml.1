Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZJKXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZJKXKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZJKXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:10:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZJKXFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:05:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Frederik Deweerdt" <frederik.deweerdt@xprog.eu>,
       "" <lars_ericsson@telia.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.hnD.I0l0KB@chimera>
Subject: [Bug #14185] Oops in driversbasefirmware_class
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14185
Subject		: Oops in driversbasefirmware_class
Submitter	:  <lars_ericsson@telia.com>
Date		: 2009-09-17 05:09 (25 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6e03a201bbe8137487f340d26aa662110e324b20


