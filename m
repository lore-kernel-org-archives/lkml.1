Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZBFSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZBFSsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZBFSsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:48:31 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1188 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZBFSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:48:30 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>, nbd@openwrt.org
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
Date: Fri, 6 Feb 2009 13:48:09 -0500
Message-Id: <20090206184156.M22909@bobcopeland.com>
In-Reply-To: <pWZw1SZjMCH.A.uoH.6vYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.uoH.6vYiJB@chimera>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.121 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Feb 2009 11:23:57 +0100 (CET), Rafael J. Wysocki wrote
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
> Subject		: ath5k related kernel panic in 2.6.29-rc1
> Submitter	: Sergey S. Kostyliov <rathamahata@gmail.com>
> Date		: 2009-01-12 7:38 (24 days old)
> References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
> Handled-By	: Bob Copeland <me@bobcopeland.com>

Yes, this should still be listed.  Seems there is corruption of the rate
indexes but I haven't found it yet.  Felix Fietkau added to CC in case
he has any thoughts.

-- 
Bob Copeland %% www.bobcopeland.com


