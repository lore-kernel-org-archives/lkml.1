Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZBKEIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZBKEIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZBKEIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:08:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38553 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZBKEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:08:23 -0500
Date: Tue, 10 Feb 2009 21:08:06 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Message-ID: <20090211040806.GQ31509@parisc-linux.org>
References: <1232117771.3224.21.camel@localhost.localdomain> <20090117211723.GB30719@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117211723.GB30719@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 02:17:23PM -0700, Matthew Wilcox wrote:
> On Fri, Jan 16, 2009 at 09:56:11AM -0500, James Bottomley wrote:
> >       mpt fusion: Add separate msi enable disable for FC,SPI,SAS
> 
> I thought we rejected this one as being completely bogus?  I certainly
> don't remember seeing even an excuse for it after I challenged it.

... no response?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
