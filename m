Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYEEVFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYEEVFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbYEEVEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:04:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbYEEVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:04:50 -0400
Date: Mon, 05 May 2008 14:04:50 -0700 (PDT)
Message-Id: <20080505.140450.48875249.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: + git-net-git-rejects.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080505130911.52b22577.akpm@linux-foundation.org>
References: <200805051905.m45J5eG7032280@imap1.linux-foundation.org>
	<20080505.125118.101401893.davem@davemloft.net>
	<20080505130911.52b22577.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 5 May 2008 13:09:11 -0700

> I noticed that there were rather a lot of changes in
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> which are not in linux-next, perhaps due to time lag.

Andrew, I think you simply have to "let go" of one side or
the other.

If you're going to base on top of linux-next, then let it run
it's course and don't try to suck in the GIT trees on top
of that which linux-next takes already.
