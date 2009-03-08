Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZCHWB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZCHWB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZCHWBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:01:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55348 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbZCHWBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:01:18 -0400
Date: Sun, 8 Mar 2009 16:01:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Message-ID: <20090308220100.GO25995@parisc-linux.org>
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com> <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com> <49B436E4.1050103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B436E4.1050103@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 02:21:40PM -0700, Yinghai Lu wrote:
> Jesse or Matthew, can you pick this patch?

Having reviewed it in light of HPA's comment, I don't have a problem
with it:

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

However, I don't think it's my place to take this patch while Jesse is
away; it doesn't feel like it's needed to be submitted between -rc7 and
2.6.29.  Do you have a reason that it needs to be merged more urgently
than 2.6.30-rc1?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
