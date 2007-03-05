Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXCENXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXCENXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbXCENXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:23:06 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:38953 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470AbXCENXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:23:04 -0500
Date: Mon, 5 Mar 2007 14:23:31 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070305132331.GF3693@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.248.27.59
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 05 Mar 2007 14:22:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I'm not sure what version did exacly caused susped to disk problems but
anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
even emit ACPI interrupts. Suspend to ram works nicely.

-- 
Luká¹ Hejtmánek
