Return-Path: <linux-kernel-owner+w=401wt.eu-S1422894AbXBHCak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422894AbXBHCak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422902AbXBHCaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:30:39 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36533 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422894AbXBHCaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:30:39 -0500
Subject: Git backlight subsystem tree
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Marcin Juszkiewicz <openembedded@hrw.one.pl>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 02:30:26 +0000
Message-Id: <1170901826.5859.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm thinking of more officially volunteering to maintain the Linux
backlight class/subsystem and have been trying to sort out the various
pending patches. I've made a backlight tree available as:

http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm

(or git://git.o-hand.com/linux-rpurdie-backlight)

This has a for-mm branch containing the backlight patches I've sorted
out so far. I still have some others left to deal with which are
probably more invasive and will need discussion and testing which I'll
send some mails about soon.

I'm planning to setup an LED drivers/class tree too, I have a couple of
pending patches for that.

Cheers,

Richard



