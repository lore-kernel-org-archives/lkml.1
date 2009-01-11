Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZAKRlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZAKRlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZAKRle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:41:34 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:51734 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZAKRld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:41:33 -0500
Date: Sun, 11 Jan 2009 18:41:59 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Another libata error related to OCZ SSD
Message-ID: <20090111174159.GC4250@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 11 Jan 2009 18:41:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I encountered another problem with the OCZ SSD disk. If I suspend to ram while
running from batteries, my disk disappears. I had no problem with suspends on
AC power.

I created a screenshot of dmesg mesages:
http://www.fi.muni.cz/~xhejtman/IMG_3221.JPG

-- 
Luká¹ Hejtmánek
