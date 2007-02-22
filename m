Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXBVC5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXBVC5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXBVC5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:57:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXBVC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:57:43 -0500
Date: Wed, 21 Feb 2007 18:57:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Message-Id: <20070221185739.0d509c0d.akpm@linux-foundation.org>
In-Reply-To: <17885.636.133245.572876@notabene.brown>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
	<20070221144806.e6eed85c.akpm@linux-foundation.org>
	<17885.636.133245.572876@notabene.brown>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 13:39:56 +1100 Neil Brown <neilb@suse.de> wrote:

> I must right code that Andrew can read.

That's write.

But more importantly, things that people can immediately see and understand
help reduce the possibility of mistakes.  Now and in the future.

If we did all loops like that, then it'd be the the best way to do it in new code,
because people's eyes and brains are locked into that idiom and we just
don't have to think about it when we see it.
