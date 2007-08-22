Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbXHVXEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbXHVXEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXHVXEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:04:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:55109 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757890AbXHVXEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:04:30 -0400
Date: Thu, 23 Aug 2007 01:04:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Kees Cook <kees@outflux.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
In-Reply-To: <20070822155833.5142e588.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708230101490.7792@jikos.suse.cz>
References: <Pine.LNX.4.64.0708221750340.7792@jikos.suse.cz>
 <20070822155833.5142e588.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Andrew Morton wrote:

> My main concern right now is to try to stabilise the rc3-mm1 mess, so I 
> think I'll duck this for now.

OK, I'll clean the ifdefs up and resubmit to you when -mm stabilizes a 
little bit.

Thanks,

-- 
Jiri Kosina
