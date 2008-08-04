Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbYHDVMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbYHDVMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbYHDVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:11:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53955 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbYHDVLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:11:34 -0400
Message-ID: <4897707B.60404@garzik.org>
Date: Mon, 04 Aug 2008 17:11:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ben Dooks <ben-linux@fluff.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.27-rc1
References: <1217800985.4179.55.camel@localhost.localdomain>	<20080804142927.GG8301@fluff.org.uk> <20080804151533.6fb01b0a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804151533.6fb01b0a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I thought group (or non-person) submissions where explicitly
>> prohibitted in the signoff section in Documentation/SubmittingPatches
> 
> Highpoint is a legal entity so highpoint can enter into agreements. Thats
> a bit different from say "Dave the anonymous ferret" or "three people
> down the pub"
> 
> In many ways companies that sign the patches themselves are being nicer
> to their employees than those who encourage the current practise.

(NOTE!! speaking for myself, not for other Red Hatters)

The solution I've settled upon is jgarzik@redhat.com for sign-offs, and 
my usual addresses (jeff@garzik, jgarzik@pobox) for all email 
communication and patch posting.

That makes it clear who is really signing off on the patches, while 
still ensuring that if I get fired or leave Red Hat, the flow of 
communication can be largely uninterrupted.

For those who don't know, to prevent sensitive information leaks, it is 
standard corporate policy for many companies these days to immediately 
yank an email address the minute an employee's status changes.

	Jeff


