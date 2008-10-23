Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYJWVkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYJWVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYJWVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:40:12 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:62525 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYJWVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:40:10 -0400
X-IronPort-AV: E=Sophos;i="4.33,472,1220227200"; 
   d="scan'208";a="98292864"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [git pull] bdev API series
References: <20081023100124.GK28946@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 23 Oct 2008 14:40:08 -0700
In-Reply-To: <20081023100124.GK28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 23 Oct 2008 11:01:24 +0100")
Message-ID: <adazlkvrnwn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2008 21:40:09.0323 (UTC) FILETIME=[EBEACBB0:01C93557]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it would be worth trying to get the patch descriptions a little
better for future trees at least -- if I'm reading through a shortlog or
something and I see:

 >       switch ubd
 >       switch DAC960
 >       switch amiflop
 >       switch aoeblk
 >       switch ataflop

then it's not exactly clear what those patches do (without the context
of the full series handy).

 - R.
