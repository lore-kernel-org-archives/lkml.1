Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0CNH6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:58:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40602 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755378Ab0CNH6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:58:39 -0400
Date: Sun, 14 Mar 2010 08:58:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.34-rc1: regression: ^Z no longer stops sound
Message-ID: <20100314075831.GA13457@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
thinkpad and geode notebook).

On 2.6.34-rc1, hit ^Z and sound starts looping.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
