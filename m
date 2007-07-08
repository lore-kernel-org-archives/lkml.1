Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXGHVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXGHVF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXGHVFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:05:19 -0400
Received: from gherkin.frus.com ([192.158.254.49]:53280 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbXGHVFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:05:18 -0400
Subject: Re: 2.6.22-rc6 bad page error
In-Reply-To: <Pine.LNX.4.64.0707071852240.12481@blonde.wat.veritas.com>
 "from Hugh Dickins at Jul 7, 2007 07:38:58 pm"
To: Hugh Dickins <hugh@veritas.com>
Date: Sun, 8 Jul 2007 16:05:12 -0500 (CDT)
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070708210512.7EE80DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> (...) I'm expecting this to be a regression we introduced in
> 2.6.15, rather than recently in 2.6.22 (now, that's better isn't it ;-?)

I was reasonably certain this wasn't a recent regression.  I share a set
of speakers between two machines, and I hadn't used sound on the Alpha
in quite a while.

> Thanks for reporting: please let us all know whether this
> patch does fix your problem: I may be guessing wrong.

ACK.  I'll build the kernel today, and fire up the test fixture
tomorrow.

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
