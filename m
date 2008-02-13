Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYBMNv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYBMNv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYBMNvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:51:48 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:35600 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYBMNvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:51:47 -0500
Date: Wed, 13 Feb 2008 14:51:43 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc1 regression - ondemand governor does not work at all
Message-ID: <20080213135143.GA4345@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 13 Feb 2008 14:51:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of 2.6.25-rc1, ondemand governor from cpufreq (acpi-p states driver) does
not change frequency. Machine is still running at max frequency regardless of
system load.

-- 
Luká¹ Hejtmánek
