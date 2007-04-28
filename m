Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbXD1VAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbXD1VAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXD1VAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:00:45 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4096 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXD1VAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:00:31 -0400
X-IronPort-AV: i="4.14,465,1170662400"; 
   d="scan'208"; a="141919634:sNHT42390873"
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, davidhart@tqmcube.com,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 8392] New: Hard Lock Subsequent to Boot
X-Message-Flag: Warning: May contain useful information
References: <200704281634.l3SGYhJX014704@fire-2.osdl.org>
	<20070428115906.86e93af6.akpm@linux-foundation.org>
	<20070428191851.GM3468@stusta.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Apr 2007 14:00:29 -0700
In-Reply-To: <20070428191851.GM3468@stusta.de> (Adrian Bunk's message of "Sat, 28 Apr 2007 21:18:51 +0200")
Message-ID: <adaabwsmcya.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 21:00:29.0960 (UTC) FILETIME=[40FCD080:01C789D8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > # install git and cogito on your computer
 > 
 > # clone Linus' tree:
 > cg-clone \ 
 > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Why the cogito installation?  It looks like cg-clone is the only
cogito command you use, and git-clone is a trivial replacement.

 - R.
