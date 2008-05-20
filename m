Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbYETV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbYETV6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYETV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:58:10 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4156 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYETV6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:58:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 May 2008 21:58:04.0951 (UTC) FILETIME=[94999A70:01C8BAC4]
Content-class: urn:content-classes:message
Subject: Re: UML fails to locate address space
Date: Tue, 20 May 2008 17:58:04 -0400
Message-ID: <Pine.LNX.4.61.0805201757270.13545@chaos.analogic.com>
In-Reply-To: <20080520173503.GA10811@c2.user-mode-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UML fails to locate address space
thread-index: Aci6xJSgo7BIx8mnSZqLDo/IL/kEwA==
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com> <20080520173503.GA10811@c2.user-mode-linux.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Tom Spink" <tspink@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15922.002
X-TM-AS-Result: No--7.501000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Jeff Dike wrote:

> On Tue, May 20, 2008 at 11:22:08AM -0400, linux-os (Dick Johnson) wrote:
>> Does this mean that I cannot mmap() address zero in the kernel
>> anymore? I should be able (in the kernel) read anything, and
>> then mmap() it to something usable in user-space. If address
>> zero is now artifically trapped there are problems being created
>> for no good reason at all.
>
> We're operating from userspace here.
>
> In any case, this hasn't happened with any kernel I've seen, but I'm
> suspicious that Ubuntu has started treating page zero specially.
>
> 	   	       	   Jeff
>

Yes, shouldn't be.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
