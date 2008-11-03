Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKCAdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKCAdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 19:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYKCAdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 19:33:46 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:59708 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbYKCAdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 19:33:46 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] crypto: Add Skein hash algorithm variants
Date: Mon, 3 Nov 2008 00:33:45 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gelgt9$7fk$1@taverner.cs.berkeley.edu>
References: <20081102161506.GA21940@havoc.gtf.org>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1225672425 7668 128.32.168.222 (3 Nov 2008 00:33:45 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 3 Nov 2008 00:33:45 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik  wrote:
>This is the first draft of the Skein hash algorithm that was recently
>mentioned, as a prominent submission to NIST's SHA-3 competition.

Adding Skein to the kernel makes no sense, from a cryptographic point of
view, at this point in time.  The appropriate point would be after it
has been analyzed and vetted by crypto experts over a period of time.
I suspect even the designers of Skein would advise you not to use the
algorithm until other cryptographers have had a chance to examine it and
it has been subjected to cryptanalysis over a period of time.  The same
goes for all new submissions to the NIST competition.
