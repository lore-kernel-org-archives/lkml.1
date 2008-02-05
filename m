Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYBEDCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYBEDCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYBEDCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:02:41 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64488 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYBEDCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:02:40 -0500
Message-Id: <200802050302.m1532OFk007019@www262.sakura.ne.jp>
Subject: Re: [2.6.24-mm1] TCP/IPv6 connect() oopses at twothirdsMD4Transform()
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Matt Mackall <mpm@selenic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 12:02:24 +0900
References: <200802050128.m151ShPX088549@www262.sakura.ne.jp> <20080204173652.0fbe8885.akpm@linux-foundation.org> <1202178600.17934.165.camel@cinder.waste.org>
In-Reply-To: <1202178600.17934.165.camel@cinder.waste.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> random: revert braindamage that snuck into checkpatch cleanup
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Yes. It solved the oops.

Thank you.
