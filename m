Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYLDAI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYLDAI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYLDADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:03:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbYLDADX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:03:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miles Lane" <miles.lane@gmail.com>, "Takashi Iwai" <tiwai@suse.de>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.h3G.soxNJB@chimera>
Subject: [Bug #12159] 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12159
Subject		: 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-11-27 20:33 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122781805620212&w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>


