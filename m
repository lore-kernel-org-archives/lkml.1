Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZCJLXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZCJLXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZCJLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:23:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZCJLXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:23:22 -0400
Date: Tue, 10 Mar 2009 12:23:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc5+: usb bluetooth crashes system
Message-ID: <20090310112307.GD1337@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Since switch to 2.6.29-rc, bluetooth crashes system... usually on
disconnect or killall pppd.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
