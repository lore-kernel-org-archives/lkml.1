Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXBJMDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXBJMDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXBJMDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:03:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXBJMDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:03:53 -0500
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<1171042535.29713.96.camel@pmac.infradead.org>
From: Andi Kleen <ak@suse.de>
Date: 10 Feb 2007 14:03:55 +0100
In-Reply-To: <1171042535.29713.96.camel@pmac.infradead.org>
Message-ID: <p73tzxugo5g.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On Thu, 2007-02-08 at 15:07 -0800, Andrew Morton wrote:
> > lutimesat-simplify-utime2.patch
> > lutimesat-extend-do_utimes-with-flags.patch
> > lutimesat-actual-syscall-and-wire-up-on-i386.patch
> > 
> >  Do we want this?  Ulrich says so.  Will merge, I guess.
> 
> I would strongly recommend that in the general case, you don't merge new
> system calls unless the corresponding compat_ system call is
> implemented.

... and there is a manpage ready to submit to manpages.

-Andi
