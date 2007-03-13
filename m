Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbXCMXBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbXCMXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbXCMXBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:01:51 -0400
Received: from reserv5.univ-lille1.fr ([193.49.225.19]:56366 "EHLO
	reserv5.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXCMXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:01:50 -0400
Message-ID: <45F72D37.6090004@tremplin-utc.net>
Date: Wed, 14 Mar 2007 00:01:11 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wistron_btns: More keymaps
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net>
In-Reply-To: <45ED8809.70309@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (reserv5.univ-lille1.fr [193.49.225.19]); Wed, 14 Mar 2007 00:01:31 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@tremplin-utc.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As a sequel to my patch "Wistron button support for TravelMate 610" of 
last week, here is a bigger addition of keymaps for the wistron_btns.

Patch 1 adds all the database of acerhk which fits this driver (about 25 
more laptops).
Patch 2 adds a generic map that should fit most users but has the 
disadvantage of not being automatic.

Dmitry, I've tried to make them against your tree. Still, if they don't 
apply cleanly, just tell me and I'll try harder!

See you,
Eric
