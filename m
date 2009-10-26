Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZJZTE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZJZTE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZJZTEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:04:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59371 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZJZTEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Massimo Cetra" <mcetra@navynet.it>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.B9G.nre5KB@chimera>
Subject: [Bug #14378] Problems with net/core/skbuff.c
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
Subject		: Problems with net/core/skbuff.c
Submitter	: Massimo Cetra <mcetra@navynet.it>
Date		: 2009-10-08 14:51 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4


