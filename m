Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZHSXf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZHSXf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZHSXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:35:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:65164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbZHSXf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,410,1246863600"; 
   d="scan'208";a="543028661"
Subject: Re: [Bug #13819] system freeze when switching to console
From: reinette chatre <reinette.chatre@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <ADSuNT6McuD.A.cdB.vOIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <ADSuNT6McuD.A.cdB.vOIjKB@chimera>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 16:35:28 -0700
Message-Id: <1250724928.30019.14331.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 13:26 -0700, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
> Subject		: system freeze when switching to console
> Submitter	: Reinette Chatre <reinette.chatre@intel.com>
> Date		: 2009-07-23 17:57 (28 days old)

This issue is still present in 2.6.31-rc6. Unfortunately the patches I
reverted to get a working system does not revert cleanly anymore.

Reinette


