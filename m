Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZFWTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZFWTzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZFWTzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:55:23 -0400
Received: from dan.rpsys.net ([93.97.175.187]:60189 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZFWTzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:55:21 -0400
Subject: [GIT PULL] backlight updates for 2.6.31
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 20:53:03 +0100
Message-Id: <1245786783.26606.19.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree update for 2.6.31. There wasn't going to be one
until this bugfix came in today.

Thanks, Richard

 drivers/video/backlight/tdo24m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Aviv Laufer (1):
      backlight: Fix tdo24m crash on kmalloc

-- 
Richard Purdie
Intel Open Source Technology Centre

