Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYGNRM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYGNRM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYGNRMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbYGNRMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:12:49 -0400
Date: Mon, 14 Jul 2008 10:12:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 14
Message-Id: <20080714101242.ace33488.akpm@linux-foundation.org>
In-Reply-To: <20080714201249.947400d0.sfr@canb.auug.org.au>
References: <20080714201249.947400d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 20:12:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> With the opening of the merge window, I am hoping my job becomes easier
> again ... :-)

If past experience is a guide, it's about to get harder because

a) maintainers jam untested crap^W^Wrecently-received features into
   their trees so they don't miss the merge window and

b) a storm of git rejects turn up as Linus's tree starts to get changed.

Hopefully b) will improve, as "all" the new code has already gone
through linux-next merging.

As for a), well, it would be nice if people were to be careful about
that sort of thing.  In some ways it's justifiable - we _do_ have a
couple months to fix remaining glitches.  But one would think that when
fast-tracking new features, the code would at least get additional
review and testing to make up for it.
