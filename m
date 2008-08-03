Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYHCOIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYHCOIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYHCOIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:08:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20429 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbYHCOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:08:43 -0400
X-IronPort-AV: E=Sophos;i="4.31,301,1215388800"; 
   d="scan'208";a="135131661"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches
References: <20080801153655.GP28946@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 03 Aug 2008 07:08:42 -0700
In-Reply-To: <20080801153655.GP28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 1 Aug 2008 16:36:56 +0100")
Message-ID: <adaod4aur6d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Aug 2008 14:08:42.0592 (UTC) FILETIME=[6F81E600:01C8F572]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something seems a little strange about your git worflow, with patch
descriptions such as

 >       [patch 3/4] vfs: remove unused nameidata argument of may_create()

making it in without the "[patch 3/4]" part being stripped, and even
worse descriptions such as

 >       Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree

getting committed too....

 - R.
