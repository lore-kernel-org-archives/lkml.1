Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZCaHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZCaHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZCaHNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:13:46 -0400
Received: from tservice.net.ru ([195.178.208.66]:53982 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZCaHNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:13:45 -0400
Date: Tue, 31 Mar 2009 11:13:26 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Boaz Harrosh <bharrosh@panasas.com>, avishay@gmail.com, jeff@garzik.org,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
Message-ID: <20090331071326.GA5072@ioremap.net>
References: <49C1331D.1080805@panasas.com> <20090330142200.af4b497c.akpm@linux-foundation.org> <20090331140124.a21da743.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331140124.a21da743.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Mar 31, 2009 at 02:01:24PM +1100, Stephen Rothwell (sfr@canb.auug.org.au) wrote:
> > I'm unsure when that time will come.  Who has reviewed this work and
> > what was the result?
> 
> That is a good question.  The other is "Is this destined for 2.6.30?"

There was a lengthy discussion in scsi list.
I made another review of the previous revision and we talked a bit about
ducumented features/bugs for the current one.

-- 
	Evgeniy Polyakov
