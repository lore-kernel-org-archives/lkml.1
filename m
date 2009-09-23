Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZIWHjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZIWHjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZIWHjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:39:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbZIWHjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:39:35 -0400
Date: Wed, 23 Sep 2009 00:39:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@hardeman.nu,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] input: Fix build failures
 caused by Kconfig Winbond WPCD376I Consumer IR hardware driver Kconfig
 entry
Message-Id: <20090923003918.505db5b4.akpm@linux-foundation.org>
In-Reply-To: <20090923072444.GA27150@elte.hu>
References: <20090923072444.GA27150@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 09:24:44 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> ( ob-sidenote: Andrew, i did not find the patch for commit 16af5bb on 
>   lkml and it's now upstream. It would be highly useful if you Cc:-ed 
>   lkml with submitted patches like all maintainers do, so that patterns 
>   can be grepped for and discussions can be continued quickly instead of 
>   created anew. It would also significantly increase the S/N ratio of 
>   lkml. Thanks! )

I did that a couple of times a few years back and vger had a heart
attack.  I could cc the lower-subscriber-count mm-commits but that
wouldn't help much.

16af5bb doesn't exist btw - you want e258b80e691f1f3ae83a60aa80eaf7322bd55ec4.
