Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZBXBhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZBXBhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZBXBhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:37:04 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61777 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZBXBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:37:01 -0500
X-IronPort-AV: E=Sophos;i="4.38,256,1233532800"; 
   d="scan'208";a="255474397"
From: Roland Dreier <rdreier@cisco.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       "Roland Dreier" <rolandd@cisco.com>
Subject: Re: [Bug #12491] i915 lockdep warning
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
	<vP9hdyF4fL.A.8rF.0qzoJB@chimera>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 23 Feb 2009 17:36:58 -0800
In-Reply-To: <vP9hdyF4fL.A.8rF.0qzoJB@chimera> (Rafael J. Wysocki's message of
	"Mon, 23 Feb 2009 22:48:05 +0100 (CET)")
Message-ID: <adabpssvcn9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Feb 2009 01:36:58.0765 (UTC) FILETIME=[6236D3D0:01C99620]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Patch		: http://marc.info/?l=linux-kernel&m=123378709730700&w=2

this patch is upstream now as a35f2e2b so I think we can close this one.

 - R.
