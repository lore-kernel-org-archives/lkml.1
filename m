Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab0BGWpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:45:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab0BGWp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:45:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Tejun Heo" <tj@kernel.org>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.0MC.spzbLB@chimera>
Subject: [Bug #14999] possible circular locking dependency detected in rfkill at suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
Subject		: possible circular locking dependency detected in rfkill at suspend
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:52 (33 days old)


