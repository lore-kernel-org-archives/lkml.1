Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZJZTEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZJZTEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZJZTEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:04:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZJZTE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@lst.de>,
       "Thomas Neumann" <tneumann@users.sourceforge.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.FQG.are5KB@chimera>
Subject: [Bug #14387] deadlock with fallocate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14387
Subject		: deadlock with fallocate
Submitter	: Thomas Neumann <tneumann@users.sourceforge.net>
Date		: 2009-10-07 3:00 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=125488495526471&w=4
Handled-By	: Christoph Hellwig <hch@lst.de>


