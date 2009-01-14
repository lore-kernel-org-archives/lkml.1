Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZANHfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZANHfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZANHf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:35:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:52810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754873AbZANHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:35:25 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/D25AOFlnDp/OGSgpOrjCPR9PzpD/zv4gwZNyQ9V
	1RTjwS3lEmNXlE
Message-ID: <496D95BA.4070304@gmx.net>
Date: Wed, 14 Jan 2009 08:35:22 +0100
From: Alexey Rempel <fishor@gmx.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [Bug #12420] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.PPH.GHfaJB@chimera>
In-Reply-To: <oWTznAnH9BI.A.PPH.GHfaJB@chimera>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12420
> Subject		: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
> Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> Date		: 2009-01-09 12:34 (3 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=871af1210f13966ab911ed2166e4ab2ce775b99d
> References	: http://marc.info/?l=linux-kernel&m=123150457832109&w=4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This warning was disabled in latest git.
