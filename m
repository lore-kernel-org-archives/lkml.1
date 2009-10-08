Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZJHL3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZJHL3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZJHL3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:29:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42261 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZJHL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:29:39 -0400
Date: Thu, 8 Oct 2009 13:28:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: staging: where to put system-wide includes
Message-ID: <20091008112817.GA28916@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In staging, I need some includes that will become "system-wide" at the
end.

Is it acceptable to create drivers/staging/include/linux (and
friends), and then use -I magic to include those headers?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
