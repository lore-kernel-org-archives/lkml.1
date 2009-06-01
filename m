Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZFAKOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZFAKOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZFAKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:14:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56089 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZFAKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:14:27 -0400
Date: Mon, 1 Jun 2009 12:14:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: ttyACM0: when the device dies, 2.6.30-rc7 dies, too (regression?)
Message-ID: <20090601101421.GA1914@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I believe this worked before; on 2.6.30-rc7, when ttyACM0 dies
(openmoko in bootloader powers off) the notebook I'm running minicom
on dies, too :-(. For the first time, I did not catch any messages,
I'll retry the test on console.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
