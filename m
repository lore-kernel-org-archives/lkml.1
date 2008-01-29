Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYA2Cpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYA2Cpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYA2Cp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:45:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38698 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYA2Cp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:45:26 -0500
Date: Mon, 28 Jan 2008 19:45:25 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pull request: DMA pool updates
Message-ID: <20080129024524.GA20198@parisc-linux.org>
References: <20080129001147.GD31101@parisc-linux.org> <20080128170734.3101b6aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128170734.3101b6aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 05:07:34PM -0800, Andrew Morton wrote:
> The usual form is, I believe,
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git dmapool
> 
> Otherwise people get all confused and think it's an empty tree (like I just
> did).

Sorry!

> There were no replies to v2 of the patch series.  It all looks reasonable
> from a quick scan (assuming the patches are unchanged since then).

I haven't changed them, correct.

> afaik these patches have been tested by nobody except thyself?

I've tested them myself, then I sent them to the perf team who ran the
(4 hour long) benchmark, and they reported success.  As with many patches
these days, they sank into a pit of indifference.  Perhaps I need to
take a leaf from my former government's book and sex up my patch
descriptions a bit.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
