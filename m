Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZKCK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZKCK5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZKCK5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:57:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41729 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZKCK5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:57:18 -0500
Date: Tue, 3 Nov 2009 11:57:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc5: unexpected thermal shutdown?
Message-ID: <20091103105717.GA2516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I found this in the syslog afterwards.

Nov  3 09:59:14 amd kernel: Critical temperature reached (128 C), shutting down.
Nov  3 09:59:14 amd shutdown[17819]: shutting down for system halt
Nov  3 09:59:15 amd init: Switching to runlevel: 0

Now, machine was lying on the bed at that point, so... maybe 32-rc5
consumes more power now, and maybe I was just unlucky...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
