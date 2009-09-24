Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZIXR5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZIXR5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZIXR51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:57:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39050 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZIXR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:57:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAENQu0qrR7PD/2dsb2JhbAC/RIhTAZAGBYQc
X-IronPort-AV: E=Sophos;i="4.44,446,1249257600"; 
   d="scan'208";a="395430299"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS pile 1 - misc bits
References: <20090924143242.GO14381@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 10:57:27 -0700
In-Reply-To: <20090924143242.GO14381@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 24 Sep 2009 15:32:42 +0100")
Message-ID: <ada4oqs2pko.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 17:57:27.0676 (UTC) FILETIME=[7A8D43C0:01CA3D40]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch in <http://lkml.org/lkml/2009/7/14/309> (add lockdep
annotation to s_vfs_rename_mutex to avoid lockdep spew with rename on
ecryptfs) seems to have been dropped -- or maybe it is just down in the
queue somewhere.  I did see Andrew send it to you again a week or so
back.

Thanks,
  Roland
