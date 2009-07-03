Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZGCCSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZGCCSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbZGCCSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:41789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbZGCCSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:18:18 -0400
Subject: Reminder for feature PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the
 uevent environment removal date Oct 2008
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:41:50 +0530
Message-Id: <1246587110.2530.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kay,

What:   PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
When:   October 2008
Why:    The stacking of class devices makes these values misleading and
        inconsistent.
        Class devices should not carry any of these properties, and bus
        devices have SUBSYTEM and DRIVER as a replacement.
Who:    Kay Sievers <kay.sievers@suse.de>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

