Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZFSWYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZFSWYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZFSWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:24:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54731 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFSWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:24:34 -0400
Date: Sat, 20 Jun 2009 00:24:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: iwl3945 in 2.6.31-rc0: ad-hoc mode broken?
Message-ID: <20090619222431.GA2398@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried using ad-hoc mode (against t-mobile G1) on -rc0, and was
unsuccessful -- never got dhcp. I had to reboot back to
2.6.30... Should I try it few more times or is something broken?

(Also wifi LED stopped working on x60, but that's older issue).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
