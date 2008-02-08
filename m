Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbYBHQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbYBHQHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYBHQHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:07:40 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4226 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699AbYBHQHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:07:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 08 Feb 2008 16:07:25.0349 (UTC) FILETIME=[B1E29D50:01C86A6C]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Fri, 8 Feb 2008 11:07:20 -0500
Message-ID: <Pine.LNX.4.61.0802081104370.27386@chaos.analogic.com>
In-Reply-To: <1202486247.3102.17.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] scsi_error: Fix language abuse.
Thread-Index: AchqbLHuTfr86288RHm4u//XMPxmPA==
References: <20080208153217.5fc42a50@core> <1202486247.3102.17.camel@localhost.localdomain>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-scsi@vger.kernel.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The correct word should be "invalid," in spite of
the fact that the SCSI committee used invalid syntax.

Alan is right. There is nothing illegal in the kernel
and if there is, it must be removed as soon as it
is discovered!


On Fri, 8 Feb 2008, James Bottomley wrote:

>
> On Fri, 2008-02-08 at 15:32 +0000, Alan Cox wrote:
>> The word "illegal" has a precise dictionary meaning of "prohibited by
>> law". The error messages are therefore incorrect as so far nobody has
>> made SCSI violations a criminal offence.
>
> Um, I'm really reluctant to do this without an incredibly good reason.
> Illegal is a defined term under the SCSI standards, and the messages you
> are changing actually appear with the word Illegal in the actual
> ASC/ASCQ definition.  If I accept this patch, you'll no longer be able
> to look the messages up in the relevant standard:
>
> http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf
>
> By a simple text search.
>
> I don't think the pedantry is worth the confusion ...
>
> James
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
