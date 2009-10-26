Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZJZTEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZJZTEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZJZTEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:04:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbZJZTEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?=C3=89ric=20Piel?=" <Eric.Piel@tremplin-utc.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.c_F.Xre5KB@chimera>
Subject: [Bug #14390] "bind" a device to a driver doesn't not work anymore
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14390
Subject		: "bind" a device to a driver doesn't not work anymore
Submitter	: Éric Piel <Eric.Piel@tremplin-utc.net>
Date		: 2009-10-11 0:04 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=125521979921241&w=4


