Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYDET2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYDET2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 15:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYDET1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 15:27:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37716 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYDET1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:27:54 -0400
Date: Sat, 5 Apr 2008 21:27:51 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: iwl965 in kernel 2.6.25-rc8
Message-ID: <20080405192751.GA12738@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 05 Apr 2008 21:27:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed some troubles with associating with AP. Am I supposed to do
something like this:
iwconfig wlan0 essid my_essid
ifconfig wlan0 up
iwconfig wlan0 essid my_essid

after the third command, I am associated with AP with ESSID my_essid.
If I omit any of the three commands, I cannot associate - the card reports not
associated.

-- 
Luká¹ Hejtmánek
