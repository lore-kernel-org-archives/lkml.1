Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZDVHzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZDVHzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZDVHzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:55:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46084 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZDVHzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:55:22 -0400
Date: Wed, 22 Apr 2009 09:58:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc2 to -rc1 regression on arm
Message-ID: <20090422075817.GA10992@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...it now fails to compile in arch/arm/kernel/sys_oabi-compat.c ,
complaining about missing prototypes for kmalloc/kfree.

I guess it should be easy to fix.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
