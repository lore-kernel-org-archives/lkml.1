Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYLMSoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYLMSoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYLMSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:41:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYLMSlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:41:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miles Lane" <miles.lane@gmail.com>, "Takashi Iwai" <tiwai@suse.de>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
In-Reply-To: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <T1gm2CtAHBF.A.sZH.v4_QJB@chimera>
Subject: [Bug #12159] 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Dec 2008 17:33:27 +0100 (CET)
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
Date		: 2008-11-27 20:33 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=122781805620212&w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>


