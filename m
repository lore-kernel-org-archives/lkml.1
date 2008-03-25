Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYCYAOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYCYAOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYCYAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:14:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53277
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYCYAOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:14:36 -0400
Date: Mon, 24 Mar 2008 17:14:36 -0700 (PDT)
Message-Id: <20080324.171436.229641263.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080324170048.50fc8972.akpm@linux-foundation.org>
References: <20080324163105.154a031a.akpm@linux-foundation.org>
	<20080324.164810.83653077.davem@davemloft.net>
	<20080324170048.50fc8972.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Mar 2008 17:00:48 -0700

> I dropped net-2.6.24 when its git-fetch started failing.  But I have no
> automatable way of knowing when to start picking up net-2.6.25.

I'll try to remember to create the next net tree at a suitable
time or move over to a more predictable naming convention,
perhaps something like net-next-2.6 :-)
