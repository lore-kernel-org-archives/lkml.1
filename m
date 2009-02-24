Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbZBXM0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbZBXM0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZBXM0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:26:32 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:38881 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZBXM0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:26:32 -0500
Date: Tue, 24 Feb 2009 13:26:41 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: ext4 fs question
Message-ID: <20090224122641.GA4752@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 24 Feb 2009 13:26:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is someone able to estimate how risky is to use ext4 fs without journal?

I would like to use ext4 fs on my new shiny SSD where journal writes eat MLC
erase cycles.

-- 
Luká¹ Hejtmánek
