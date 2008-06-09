Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYFIAiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYFIAiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbYFIAio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:38:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59016 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbYFIAin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:38:43 -0400
Date: Mon, 09 Jun 2008 09:38:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] add throttle to shrink_zone()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080608131203.e8cd69b7.akpm@linux-foundation.org>
References: <20080605021505.306358710@jp.fujitsu.com> <20080608131203.e8cd69b7.akpm@linux-foundation.org>
Message-Id: <20080609093741.7868.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > add throttle to shrink_zone() for performance improvement and prevent incorrect oom.
> 
> We should have a description of how all this works, please.  I thought
> that was present in earlier iterations of this patchset.
> 
> It's quite hard and quite unreliable to reverse engineer both the
> design and your thinking from the implementation.

Oh, sorry.
I'll write properly description soon.

Thans.


