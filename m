Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZG0BWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZG0BWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZG0BWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:22:49 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:60911 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZG0BWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:22:49 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Mon, 27 Jul 2009 03:22:42 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, rui.zhang@intel.com
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.f0H.XYObKB@chimera>
In-Reply-To: <H5-1lZIIeYK.A.f0H.XYObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907270322.47523.elendil@planet.nl>
X-OriginalArrivalTime: 27 Jul 2009 01:22:48.0501 (UTC) FILETIME=[C09E9650:01CA0E58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> Subject	: Warning 'Invalid throttling state, reset' gets displayed
>		  when it should not be
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> 		  http://bugzilla.kernel.org/attachment.cgi?id=21672

Rui has acked the patches [1], but AFAIK Len has not yet picked them up.

[1] http://lkml.org/lkml/2009/7/7/474
