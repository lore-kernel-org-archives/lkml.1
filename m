Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXBFLzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXBFLzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXBFLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:55:21 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:57871 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXBFLzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:55:20 -0500
Message-ID: <45C86C98.3020109@drzeus.cx>
Date: Tue, 06 Feb 2007 12:55:04 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Anderson Briglia <anderson.briglia@indt.org.br>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Lizardo Anderson (EXT-INdT/Manaus)" <anderson.lizardo@indt.org.br>,
       linux-kernel@vger.kernel.org,
       "Aguiar Carlos (EXT-INdT/Manaus)" <carlos.aguiar@indt.org.br>,
       Tony Lindgren <tony@atomide.com>,
       ext David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 4/4] Add MMC Password Protection (lock/unlock) support
 V9: mmc_sysfs.diff
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx> <45BE3E70.9050505@indt.org.br> <45BF8A28.5010605@drzeus.cx> <45BFB818.3020908@indt.org.br> <45C49FFA.70104@drzeus.cx> <45C7A2B4.10505@indt.org.br>
In-Reply-To: <45C7A2B4.10505@indt.org.br>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anderson Briglia wrote:
> Bug fixed. Is there anything else to improve?
>
>   

Great. All known issues should be fixed now.

I'm currently reorganising my -mm branch, so things might go missing
from there for a while. But it will be back eventually.

Btw, any progress on testing this with SD?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

