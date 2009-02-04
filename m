Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZBDNKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZBDNKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZBDNEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:04:54 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59107 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZBDNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:04:53 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12415] WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
Date: Wed, 4 Feb 2009 14:04:46 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tomas Winkler" <tomas.winkler@intel.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.7l.UwYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.7l.UwYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041404.46539.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 04 February 2009 11:23:55 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12415
> Subject		: WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
> Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> Date		: 2009-01-05 10:36 (31 days old)
> References	: http://marc.info/?l=linux-wireless&m=123115178019082&w=4

Patch is available but not yet upstream:
http://marc.info/?l=linux-wireless&m=123316414222201&w=2 

