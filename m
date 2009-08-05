Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbZHEIcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbZHEIcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933751AbZHEIcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:32:42 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:62823 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933730AbZHEIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:32:41 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13742] iwlagn (4965): regression when hardware rf switch is used
Date: Wed, 5 Aug 2009 10:32:38 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.i0D.fdgdKB@chimera>
In-Reply-To: <iZB3Pj-uj3M.A.i0D.fdgdKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051032.39357.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 08:32:40.0528 (UTC) FILETIME=[4B955500:01CA15A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13742
> Subject	: iwlagn (4965): regression when hardware rf switch is used

Fix has just been included in mainline: 
2833b17062536e962b60795ad6378ef5c0b7be09

Cheers,
FJP
