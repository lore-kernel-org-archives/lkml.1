Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZF2ARA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZF2ARA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZF2AQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:16:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZF2AQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:16:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brian Rogers" <brian@xyzw.org>, "Takashi Iwai" <tiwai@suse.de>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
In-Reply-To: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6JJ2m5kyucK.A.mfD.KJASKB@chimera>
Subject: [Bug #13633] [bisected] No sound on HDA Intel (ALC268)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:11:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13633
Subject		: [bisected] No sound on HDA Intel (ALC268)
Submitter	: Brian Rogers <brian@xyzw.org>
Date		: 2009-06-27 04:42 (2 days old)


