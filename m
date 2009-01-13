Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZAMILT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZAMILT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZAMILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:11:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZAMILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:11:08 -0500
Date: Tue, 13 Jan 2009 09:13:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090113081316.GA2292@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Just when I thought long merge window means less problems...

...suspend seemed to work until last tuesday or so. Now it hanged two
times; once so hard that power button powercycle did not result in
booting machine. (thinkpad x60)

I'll do some more tests...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
