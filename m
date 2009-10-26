Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZJZTGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZJZTGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZJZTGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:06:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbZJZTFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:05:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Clouter" <alex@digriz.org.uk>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.J3E.3qe5KB@chimera>
Subject: [Bug #14482] kernel BUG at fs/dcache.c:670 +lvm +md +ext3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:56:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Submitter	: Alexander Clouter <alex@digriz.org.uk>
Date		: 2009-10-23 10:30 (4 days old)
References	: http://lkml.org/lkml/2009/10/23/50


