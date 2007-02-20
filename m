Return-Path: <linux-kernel-owner+w=401wt.eu-S1030462AbXBTVrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462AbXBTVrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030460AbXBTVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:47:08 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:43293 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462AbXBTVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:47:05 -0500
Date: Tue, 20 Feb 2007 22:47:17 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070220214716.GA3690@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Tue, 20 Feb 2007 22:47:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

introducing SATA ACPI does not work for me (I've filled the bug
report: http://bugzilla.kernel.org/show_bug.cgi?id=8046) beside those error
messages, IDE performance is decreased. libata.noacpi=1 option works ok but
the performance is still slightly degraded (about 10%).

-- 
Luká¹ Hejtmánek
