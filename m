Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbZHZQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbZHZQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZHZQdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:33:37 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:62808 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbZHZQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:33:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Date: Wed, 26 Aug 2009 18:33:34 +0200
User-Agent: KMail/1.9.9
Cc: zajec5@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-acpi@vger.kernel.org,
       kernel-testers@vger.kernel.org, torvalds@linux-foundation.org
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com> <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com> <20090826075337.4230d82c.akpm@linux-foundation.org>
In-reply-To: <20090826075337.4230d82c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908261833.37310.elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 16:33:37.0495 (UTC) FILETIME=[F659CE70:01CA266A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropped unrelated CCs.)

Andrew Morton wrote:
> I'm not seeing any linux-acpi emails from Len since August 14.
> 
> So I merged this patch and shall send it along with
> 
> thermal_sys-check-get_temp-return-value.patch
> acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch

Thanks for that Andrew. Could you please do the same for my patches in
http://bugzilla.kernel.org/show_bug.cgi?id=13389 (or
http://lkml.org/lkml/2009/8/17/169)?

That BR is on the regression list for 2.6.30. The patches apply cleanly to 
current mainline.

Thanks,
FJP
