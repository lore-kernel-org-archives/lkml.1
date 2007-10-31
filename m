Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXJaT7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXJaT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXJaT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:59:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbXJaT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:59:39 -0400
Date: Wed, 31 Oct 2007 12:59:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       torvalds@linux-foundation.org, adaplas@pol.net, ak@suse.de,
       ebiederm@xmission.com, mouli@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
Message-Id: <20071031125907.ba953d4a.akpm@linux-foundation.org>
In-Reply-To: <1193793701.23935.394.camel@caritas-dev.intel.com>
References: <1193218342.23935.147.camel@caritas-dev.intel.com>
	<1193793701.23935.394.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 09:21:41 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> Can this patchset be merged into mainline kernel? This patchset has been
> in -mm tree from 2.6.23-rc2-mm2 on. Andrew Moton has suggested it to be
> merged into 2.6.24 during early merge window of 2.6.24. It was not
> merged into mainline because the 32-bit boot protocol has not been done.
> 
> But now, the 32-bit boot protocol has been merged into mainline. So can
> this patchset be merged into mainline kernel now?
> 

I stopped paying attention, sorry.  Have all the outstanding issues been
addressed?
