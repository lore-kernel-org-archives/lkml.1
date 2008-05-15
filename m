Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYEONWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYEONWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYEONWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:22:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYEONWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:22:15 -0400
Date: Thu, 15 May 2008 15:23:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: bzolnier@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org
Subject: 2.6.25 -> 2.6.26-rc1: pcmcia flash card changed name from hda to
	hdc
Message-ID: <20080515132313.GA1558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After update to 2.6.26-rc1, CF card (in pcmcia slot) moved from hda to
hdc on thinkpad x60 (and broke my scripts).

Is that intentional?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
