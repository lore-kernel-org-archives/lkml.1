Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbYBNVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbYBNVFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYBNVFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:05:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60180 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbYBNVFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:05:13 -0500
Message-ID: <47B4AD04.4000707@garzik.org>
Date: Thu, 14 Feb 2008 16:05:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: linux-next: first tree
References: <20080215003537.8911ce35.sfr@canb.auug.org.au> <47B4AC97.3040001@garzik.org>
In-Reply-To: <47B4AC97.3040001@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Please add the 'NEXT' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> to your list.  This is a throwaway meta-branch that is rebased often.

Additional FYI:

Don't be worried if "git diff master..NEXT" is empty from time to time.

This condition occurs whenever the 'NEXT' queue is empty.

	Jeff



