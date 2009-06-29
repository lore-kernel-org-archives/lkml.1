Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZF2ShO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZF2ShO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZF2ShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:37:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZF2ShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:37:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Problems with snd-hda-intel on hp 6930p (2.6.30)
Date: Mon, 29 Jun 2009 20:37:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906292037.09597.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

I have a problem with snd-hda-intel from 2.6.30 on an hp EliteBook 6930p, which
is that the sound is not audible, although everything appears to work just
fine.  Except maybe that when the box is rebooted and KDE (3.5) is started,
the master control is "muted" and the led indicator next to the keyboard shows
"no sound".  Then, changing the "muted" status of the master control doesn't
change the state of the led indicator and vice versa (the two things appear to
be totally independent of each other).

Can you please tell me what I can do to debug this issue?

Best,
Rafael
