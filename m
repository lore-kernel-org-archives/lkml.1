Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYBYJj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYBYJj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYBYJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:39:18 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:34713 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYBYJjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:39:17 -0500
Date: Mon, 25 Feb 2008 10:39:14 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080225093914.GB4375@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 25 Feb 2008 10:39:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

2.6.25-rc2-git7 has regression, thinkpad keys do not work any more.

Probably this commit broke things 6c231bd5eb07ce546517019f334652b9ecfc329a

-- 
Luká¹ Hejtmánek
