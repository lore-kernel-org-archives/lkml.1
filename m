Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbYBNV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbYBNV0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbYBNV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:26:31 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47391 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbYBNV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:26:29 -0500
Subject: Re: linux-next: first tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
In-Reply-To: <47B4AC97.3040001@garzik.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	 <47B4AC97.3040001@garzik.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 15:26:21 -0600
Message-Id: <1203024381.3158.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 16:03 -0500, Jeff Garzik wrote:
> Stephen Rothwell wrote:
> > Also, more trees please ...  :-) 
> 
> Please add the 'NEXT' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> to your list.  This is a throwaway meta-branch that is rebased often.
> 
> The 'master' branch of libata-dev.git always contains the base commit 
> from torvalds/linux-2.6.git from which all other branches are based.  I 
> never ever commit to the 'master' branch, only update it from 
> torvalds/linux-2.6.git.
> 
> 
> Andrew,
> 
> I will continue to maintain the 'ALL' branch exactly as before.  It may 
> contain changes not suitable for 'NEXT', but suitable for -mm testing.
> 
> In my new development process, things will almost always land in 'ALL' 
> before 'NEXT'.

So does this indicate the meaning of upstream and upstream-fixes is
still the same?  I always took upstream-fixes to be bug fixes for this
-rc and upstream as queued for the next merge window, in which case NEXT
would be the union of those two sets?

James


