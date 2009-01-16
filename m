Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbZAPI1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbZAPI1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZAPI1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZAPI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:23 -0500
Date: Fri, 16 Jan 2009 09:27:18 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: /sys/devices/system/cpu: all zeros? (2.6.29-rc1)
Message-ID: <20090116082718.GA16806@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pavel@amd:/sys/devices/system/cpu$ grep . *
kernel_max:0
online:0
possible:0
present:0
pavel@amd:/sys/devices/system/cpu$ 

Maybe it has something to do with !CONFIG_SMP?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
