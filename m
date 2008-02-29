Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbYB2Akr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbYB2Akr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761909AbYB2AkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:40:17 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44520 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761724AbYB2AkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:40:16 -0500
Date: Thu, 28 Feb 2008 17:39:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080229003954.GA525@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx> <1204180441-8540-4-git-send-email-matthew@wil.cx> <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <20080228071822.GA13571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228071822.GA13571@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:18:23AM +0100, Ingo Molnar wrote:
> very nice work!
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks!

Stephen, I've put the semaphore patches into a git tree; can you add it
to linux-next?

http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
