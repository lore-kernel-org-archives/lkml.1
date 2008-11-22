Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYKVWhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYKVWhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYKVWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830AbYKVWaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:30:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Weibler" <bugzilla-kernel@jensthebrain.de>,
       "Takashi Iwai" <tiwai@suse.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.l5B.O7HKJB@chimera>
Subject: [Bug #12061] snd_hda_intel: power_save: sound cracks on powerdown
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12061
Subject		: snd_hda_intel: power_save: sound cracks on powerdown
Submitter	: Jens Weibler <bugzilla-kernel@jensthebrain.de>
Date		: 2008-11-18 12:07 (5 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


