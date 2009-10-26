Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZJZTMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZJZTMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZJZTDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:03:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZJZTDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:03:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Miles Lane" <miles.lane@gmail.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.6gH.Gse5KB@chimera>
Subject: [Bug #14353] BUG: sleeping function called from invalid context at kernel/mutex.c:280
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14353
Subject		: BUG: sleeping function called from invalid context at kernel/mutex.c:280
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-05 3:39 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125471432208671&w=4


