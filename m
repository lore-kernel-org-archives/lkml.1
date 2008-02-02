Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYBBMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYBBMZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 07:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbYBBMZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 07:25:08 -0500
Received: from ozlabs.org ([203.10.76.45]:58907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbYBBMZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 07:25:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8): undefined reference to `LGUEST_PAGES_regs_trapnum'
Date: Sat, 2 Feb 2008 23:25:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu>
In-Reply-To: <20080201170551.GA3825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802022325.04566.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 04:05:51 Ingo Molnar wrote:
> looks similar to the previous one so i guess my quick fix attempt was a
> bit too quick. Will turn lguest off again. And i'm willing to test
> patches as well :)

Yes, sorry, I've been completely busy at linux.conf.au.

Will test and fix.

Thanks for the feedback,
Rusty.
