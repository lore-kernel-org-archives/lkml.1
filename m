Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZHZJ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZHZJ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbZHZJ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:29:39 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:51338 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351AbZHZJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:29:38 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Wed, 26 Aug 2009 11:29:38 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <Cg6cQYLdUxG.A.TcC.r1GlKB@chimera>
In-Reply-To: <Cg6cQYLdUxG.A.TcC.r1GlKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908261129.39250.elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 09:29:40.0072 (UTC) FILETIME=[BC771680:01CA262F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 August 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> Subject	: Warning 'Invalid throttling state, reset' gets displayed
>		  when it should not be
> Submitter	: Frans Pop <elendil@planet.nl> 
> Date		: 2009-05-26 15:24 (92 days old)
> Handled-By	: Frans Pop <elendil@planet.nl>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> 		  http://bugzilla.kernel.org/attachment.cgi?id=21672

Still waiting for Len (or somebody) to pick them up.

Slightly improved versions of the patches (as also sent to the mailing 
list recently) are at:
- http://bugzilla.kernel.org/attachment.cgi?id=22857
- http://bugzilla.kernel.org/attachment.cgi?id=22858

Cheers,
FJP
