Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXJXNUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXJXNUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXJXNU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:20:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51391 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbXJXNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:20:27 -0400
Message-ID: <471F4692.1080309@garzik.org>
Date: Wed, 24 Oct 2007 09:20:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 2)
References: <200710131825.24768.bzolnier@gmail.com> <20071014001238.GP8181@ftp.linux.org.uk> <4713C568.2060708@garzik.org> <20071015195807.GF8759@flint.arm.linux.org.uk> <4713C893.3050200@garzik.org> <20071024123851.GB32333@flint.arm.linux.org.uk> <471F4035.4030507@garzik.org> <20071024131243.GC32333@flint.arm.linux.org.uk>
In-Reply-To: <20071024131243.GC32333@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Wed, Oct 24, 2007 at 08:53:09AM -0400, Jeff Garzik wrote:
>> Russell King wrote:
>>> On Mon, Oct 15, 2007 at 04:07:47PM -0400, Jeff Garzik wrote:
>>>> Russell King wrote:
>>>>> On Mon, Oct 15, 2007 at 03:54:16PM -0400, Jeff Garzik wrote:
>>>>>> Al Viro wrote:
>>>>>>> Proposed addition to icside part, provided that ARM folks ACK it - gets
>>>>>>> icside to build and AFAICS it's correct:
>>>>>> ACK from me too...  ARM folks?
>>>>> Will test tomorrow/Wednesday.
>>>> Thanks.  Sorry about missing your CC on the libata-wide ata_link 
>>>> changes.  We should have poked the maintainers on that, for the drivers 
>>>> we cannot build ourselves.
>>> I think Viro's patch got an ack from everyone.  Who's dealing with getting
>>> this regression fix into mainline?  It seems at the moment the patch is in
>>> limbo.
>> I was waiting on you, who last said "Will test tomorrow/Wednesday" (with 
>> presumably an ACK forthcoming after test results)
>>
>> If it now has your ACK, it's ready and waiting in my mbox queue to be 
>> merged upstream.
> 
> Looks like it got my ack more than a week ago:

Groovy.

	Jeff



