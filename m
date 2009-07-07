Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZGGTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZGGTNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZGGTN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:13:26 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61632 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZGGTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:13:26 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13651] Anyone know what happened with PC speaker in 2.6.30?
Date: Tue, 7 Jul 2009 21:13:17 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ken Witherow" <ken@krwtech.com>, "Michael Tokarev" <mjt@tls.msk.ru>,
       "Takashi Iwai" <tiwai@suse.de>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.nYG.7_oUKB@chimera>
In-Reply-To: <bXZeuxPQAWE.A.nYG.7_oUKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072113.18608.elendil@planet.nl>
X-OriginalArrivalTime: 07 Jul 2009 19:13:19.0626 (UTC) FILETIME=[FD1776A0:01C9FF36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13651
> Subject	: Anyone know what happened with PC speaker in 2.6.30?
> Submitter	: Michael Tokarev <mjt@tls.msk.ru>
> Date		: 2009-06-15 14:41 (22 days old)
> References	: http://marc.info/?l=linux-kernel&m=124507695427817&w=4

Given the last comments from Michael I think this should be closed as "not 
a bug". The observed behavior is intended.
See: http://lkml.org/lkml/2009/6/29/232.

Cheers,
FJP
