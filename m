Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYHKRLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYHKRLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYHKRLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:11:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42362 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHKRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:11:38 -0400
Date: Mon, 11 Aug 2008 11:11:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
Cc: Adrian Bunk <bunk@kernel.org>, grundler@parisc-linux.org, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080811171136.GS8618@parisc-linux.org>
References: <20080811104643.GA3338@cs181140183.pp.htv.fi> <20080811145652.100E74E77@hiauly1.hia.nrc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811145652.100E74E77@hiauly1.hia.nrc.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:56:51AM -0400, John David Anglin wrote:
> This file was included before the SCO situation arose.  The copyright
> notice is similar to most.  Checking 2.6.22.19, I see that more than
> half the .c files lack MODULE_LICENSE("GPL") lines.
> 
> I don't understand why we are talking about HP here.  According to
> Matthew, his last commit to this file occured while he worked for
> Genedata.

Whoops, that was in the linux-2.2 CVS repository.  There were subsequent
commits in the 2.4/2.5/2.6 repositories, some of which HP might have
a claim to.

> It is my understanding that copyright normally acrues
> to employers in employment situations.  If Matthew was an employee
> and not an independent contractor at the time, then why are we not
> talking about Genedata, or its subsequent owner?

While I don't have a copy of my employment contract with Genedata any
more, my recollection is that they did not claim copyright on works I
produced that were off company time.  It would be governed by Swiss law
which I believe would not permit such a term in the contract.

> Subsequent
> employment at HP or their funding of the parisc port shouldn't
> affect the licensing of a file that was previously contributed.

That's my basic argument.  If binfmt_elf had contained the GPL
boilerplate, I would have copied that when creating binfmt_som.  It was
intended to be GPL, it was a derivative work of GPL file (that also
didn't explicitly state it was GPL), it has been treated as GPL for
almost a decade.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
