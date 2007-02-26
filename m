Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXBZA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXBZA7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933719AbXBZA7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:59:22 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55099 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXBZA7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:59:21 -0500
Date: Mon, 26 Feb 2007 01:59:17 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc1 dims my LCD
Message-ID: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

2.6.21-rc1 on my ibm t42p dims a LCD after some time (I guess it happens 
at the time the console should normally be blanked). 

When I hit the keyboard, the brightness stays low (it's 50% of light or 
so, so I could read what's on the screen, but it's uncomfortably dim), and 
I have to manually raise the brightness on the LCD. Quite annoying :)

I have bisected this to your commit 
994efacdf9a087b52f71e620b58dfa526b0cf928

Thanks,

-- 
Jiri Kosina
