Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbZJEMxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbZJEMxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZJEMxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:53:13 -0400
Received: from [83.228.35.12] ([83.228.35.12]:58712 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZJEMxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:53:12 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 08:53:12 EDT
Message-ID: <4AC9EAC2.5000705@fs.ru.acad.bg>
Date: Mon, 05 Oct 2009 15:46:58 +0300
From: PVP <pvp-lsts@fs.ru.acad.bg>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14214] BUG at drivers/scsi/scsi_lib.c:1108!
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <Q3xT3CnoTGE.A.QTH.f4SxKB@chimera>
In-Reply-To: <Q3xT3CnoTGE.A.QTH.f4SxKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki написа:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14214
> Subject		: BUG at drivers/scsi/scsi_lib.c:1108!
> Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
> Date		: 2009-09-23 11:13 (9 days old)
> 
> 
Sorry for the late answer - I had ISP troubles.

The above bug entry should NOT be listed, because the problem
was fixed in 2.6.32-rc1, and Jens Axboe pointed me the exact
commit, which solves my problems (it was raid related).

Thanks,
Plamen Petrov
