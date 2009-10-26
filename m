Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZJZTKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZJZTKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZJZTKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:10:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59384 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZJZTE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.7tG.jre5KB@chimera>
Subject: [Bug #14380] Video tearing/glitching with T400 laptops
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14380
Subject		: Video tearing/glitching with T400 laptops
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2009-10-02 22:40 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=125452324520623&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://marc.info/?l=linux-kernel&m=125591495325000&w=4


