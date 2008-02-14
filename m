Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbYBNVDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbYBNVDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbYBNVD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:03:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60167 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695AbYBNVD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:03:27 -0500
Message-ID: <47B4AC97.3040001@garzik.org>
Date: Thu, 14 Feb 2008 16:03:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: linux-next: first tree
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Also, more trees please ...  :-) 

Please add the 'NEXT' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

to your list.  This is a throwaway meta-branch that is rebased often.

The 'master' branch of libata-dev.git always contains the base commit 
from torvalds/linux-2.6.git from which all other branches are based.  I 
never ever commit to the 'master' branch, only update it from 
torvalds/linux-2.6.git.


Andrew,

I will continue to maintain the 'ALL' branch exactly as before.  It may 
contain changes not suitable for 'NEXT', but suitable for -mm testing.

In my new development process, things will almost always land in 'ALL' 
before 'NEXT'.

	Jeff



