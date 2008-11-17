Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYKQWIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYKQWIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYKQWIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:08:44 -0500
Received: from eazy.amigager.de ([213.239.192.238]:53971 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYKQWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:08:43 -0500
Date: Mon, 17 Nov 2008 23:08:51 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12038] Suspend regression in stable kernel 2.6.27.4 on
	Mac mini Core Duo
Message-ID: <20081117220851.GA6314@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.sUE.LAGIJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Q7OAnAv0V3D.A.sUE.LAGIJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 17:35:21 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12038
> Subject		: Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
> Submitter	: Tino Keitel <tino.keitel@gmx.de>
> Date		: 2008-11-09 20:28 (8 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=66036f5862883fcc9f7ff8550685a5a3de1a57e4
> References	: http://marc.info/?l=linux-kernel&m=122626258429689&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://marc.info/?l=linux-kernel&m=122661443120581&w=4

The patch works fine here. I applied it to 2.6.27.5 and resume works.

Regards,
Tino
