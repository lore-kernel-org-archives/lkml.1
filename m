Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbZLKT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbZLKT1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbZLKT04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:26:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33555 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbZLKT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:26:56 -0500
Date: Fri, 11 Dec 2009 20:26:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc0: console tones changed?
Message-ID: <20091211192657.GA1964@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


^G now produces different sound than before. I am using

    /bin/echo -e "\33[10;5000]\33[11;50]\33[?18;0;136c\33[?102m"

to set up different sound than usual...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
