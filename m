Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZBIBMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZBIBMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZBIBMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:12:24 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52387 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBIBMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:12:23 -0500
X-IronPort-AV: E=Sophos;i="4.37,401,1231113600"; 
   d="scan'208";a="245401086"
From: Roland Dreier <rdreier@cisco.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [Bug #12600] i915 lockdep warning
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.xaG.-20jJB@chimera>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 08 Feb 2009 17:12:21 -0800
In-Reply-To: <sWhNs83kKPE.A.xaG.-20jJB@chimera> (Rafael J. Wysocki's message
	of "Sun, 8 Feb 2009 20:21:42 +0100 (CET)")
Message-ID: <adaljsgbeh6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2009 01:12:21.0940 (UTC) FILETIME=[75C2F740:01C98A53]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12600
 > Subject		: i915 lockdep warning
 > Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
 > Date		: 2009-01-13 23:17 (27 days old)
 > References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4

Looks like a dup of 12491 to me.

 - R.
