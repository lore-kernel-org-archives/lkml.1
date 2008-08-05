Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbYHEVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbYHEVTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYHEVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:18:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44898 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763393AbYHEVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:18:56 -0400
Date: Tue, 5 Aug 2008 23:20:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc1: softcursor behaviour changed
Message-ID: <20080805212004.GA1592@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 2.6.26, this 

    echo -e "\33[10;5000]\33[11;50]\33[?18;0;136c\33[?102m"

produces some variation on cursor. on 2.6.27-rc1, I have no cursor at
all :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
