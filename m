Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbZBDNKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbZBDNKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbZBDNHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:07:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39765 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZBDNHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:07:32 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12495] thinkpad problems during resume
Date: Wed, 4 Feb 2009 14:06:50 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.tOH.wvYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.tOH.wvYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041406.50578.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 04 February 2009 11:23:58 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12495
> Subject		: thinkpad problems during resume
> Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> Date		: 2009-01-17 15:48 (19 days old)
> First-Bad-Commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h
>=e39ad415ac15116df213dfa2aa2a4f1b0857af9c References	:
> http://marc.info/?l=linux-kernel&m=123220746125479&w=4
> http://marc.info/?l=linux-kernel&m=123170361827197&w=4
> Handled-By	: Mike Travis <travis@sgi.com>
> Patch		: http://lkml.org/lkml/2009/1/16/375
> 		  http://lkml.org/lkml/2009/1/16/376
> 		  http://lkml.org/lkml/2009/1/16/378

Fixed upstream. 
