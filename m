Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYKVWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYKVWe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYKVWaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987AbYKVWaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:30:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey" <azure@fast.net.ua>, "Takashi Iwai" <tiwai@suse.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.qMC.e7HKJB@chimera>
Subject: [Bug #12034] snd-hda-intel on Realtek ALC268 chip shows only Master volume (for playback)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12034
Subject		: snd-hda-intel on Realtek ALC268 chip shows only Master volume (for playback)
Submitter	: Sergey <azure@fast.net.ua>
Date		: 2008-11-15 04:20 (8 days old)


