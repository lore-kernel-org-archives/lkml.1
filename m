Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbXGKInH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbXGKInH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbXGKIm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:42:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50994 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbXGKImz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:42:55 -0400
Date: Wed, 11 Jul 2007 09:42:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: revoke (Was: -mm merge plans for 2.6.23)
Message-ID: <20070711084253.GT21668@ftp.linux.org.uk>
References: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:41:35AM +0300, Pekka Enberg wrote:
> Hi Andrew,
> 
> On 7/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >revoke-special-mmap-handling.patch
> >revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
> >revoke-core-code.patch
> >revoke-support-for-ext2-and-ext3.patch
> >revoke-add-documentation.patch
> >revoke-wire-up-i386-system-calls.patch
> >fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
> >revoke-vs-git-block.patch
> >
> > Don't know.  Need to ping suitable developers over this work.
> 
> Well, revoke is in limbo land waiting for the VFS maintainers to take
> a look at it...

Could you send a sanely split series against the .22 to fsdevel?
