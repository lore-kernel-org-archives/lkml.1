Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbZCCWNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbZCCWNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZCCWIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:08:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909AbZCCWId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:08:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Weibler" <bugzilla-kernel@jensthebrain.de>,
       "Takashi Iwai" <tiwai@suse.de>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.kxD.FfarJB@chimera>
Subject: [Bug #12061] snd_hda_intel: power_save: sound cracks on powerdown
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:35:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12061
Subject		: snd_hda_intel: power_save: sound cracks on powerdown
Submitter	: Jens Weibler <bugzilla-kernel@jensthebrain.de>
Date		: 2008-11-18 12:07 (106 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


