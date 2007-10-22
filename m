Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXJVW5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXJVW5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXJVW4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:56:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbXJVW4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:56:51 -0400
Date: Mon, 22 Oct 2007 15:56:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: bharata@linux.vnet.ibm.com, jblunck@suse.de, agruen@suse.de, hch@lst.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Use struct path in struct nameidata
Message-Id: <20071022155634.f61c9d43.akpm@linux-foundation.org>
In-Reply-To: <20071022135758.GA17051@lst.de>
References: <20071022065352.GA6489@in.ibm.com>
	<20071022135758.GA17051@lst.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 15:57:58 +0200
Christoph Hellwig <hch@lst.de> wrote:

> 
> Any reason we've got this patchset posted by three people now? :)

presumably because I haven't been merging it.

I was in bugfix-only mode from a week prior to 2.6.24 release and during
the merge window.  Partly caused by the already-idiotic amount of stuff we
had queued for 2.6.24, partly because we needed to concentrate on
stabilising the 2.6.25 patchpile rather than writing new stuff.

And partly to send the signal that rather than beavering away on new
features all the time, we should also be spending some (more) time testing,
reviewing and bugfixing the current and soon-to-be-current code.

Probably I should have been more explicit about it, but it wasn't really
planned.  Next time I'll send more "thanks, I parked this for consideration
at a more appropriate time" emails.

