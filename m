Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbYBFOG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbYBFOG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYBFOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:06:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50694 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbYBFOGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:06:16 -0500
Date: Wed, 6 Feb 2008 13:58:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: any cpu hotplug changes in 2.6.24-current-git?
Message-ID: <20080206125807.GB26817@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Are there any recent changes in cpu hotplug? I have suspend (random)
problems, nosmp seems to fix it, and last messages in the "it hangs"
case are from cpu hotplug...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
