Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYDUW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYDUW5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYDUW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:57:30 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:56494 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYDUW53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:57:29 -0400
X-IronPort-AV: E=Sophos;i="4.25,691,1199692800"; 
   d="scan'208";a="22797971"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [GIT]: Sparc
References: <20080421.153231.108090227.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 21 Apr 2008 15:50:37 -0700
In-Reply-To: <20080421.153231.108090227.davem@davemloft.net> (David Miller's
	message of "Mon, 21 Apr 2008 15:32:31 -0700 (PDT)")
Message-ID: <adak5iqakle.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 22:50:37.0323 (UTC) FILETIME=[1D94A5B0:01C8A402]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This performs the scheduled removal of Solaris and SunOS
 > system call for sparc, much to the chagrin of Al Viro
 > and others :-) (in particular, that asm/namei.h crud can
 > now die)

Maybe this is an inside joke I don't get, but why are we merging
something that causes Al Viro and others to feel chagrin?

 - R.
