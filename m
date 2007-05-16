Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXEPRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXEPRwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758808AbXEPRwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:52:11 -0400
Received: from lazybastard.de ([212.112.238.170]:52081 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbXEPRwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:52:10 -0400
Date: Wed, 16 May 2007 19:47:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-ID: <20070516174747.GF8113@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org> <20070516101535.94e44b3b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516101535.94e44b3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 10:15:35 -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 19:01:14 +0200 Jörn Engel <joern@lazybastard.org> wrote:
> 
> > This patch introduces a new flag, I_SYNC and seperates out all sync()
> > users of I_LOCK to use the new flag instead.
> 
> gack, you like sticking your head in dark and dusty holes.

I don't remember enjoying the experience too much.  For a day or two I
was thinking about quitting and becoming a monk somewhere.

> If we're going to do this then please let's get some exhaustive commentary
> in there so that others have a chance of understanding these flags without
> having to do the amount of reverse-engineering which you've been put through.

Not sure how the monasteries would cope with that.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
