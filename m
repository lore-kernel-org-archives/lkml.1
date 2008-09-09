Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYIIMBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYIIMBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYIIMB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:01:28 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4094 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYIIMB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:01:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 09 Sep 2008 11:59:36.0071 (UTC) FILETIME=[87815970:01C91273]
Content-class: urn:content-classes:message
Subject: Re: Linux 2.6.25.17
Date: Tue, 9 Sep 2008 07:59:45 -0400
Message-ID: <Pine.LNX.4.61.0809090753120.19620@chaos.analogic.com>
In-Reply-To: <20080908210656.GA3852@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.25.17
Thread-Index: AckSc4eN2pZwAmUmQbqFlB3N7rUKjg==
References: <20080908143516.GA7311@suse.de> <Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com> <20080908210656.GA3852@suse.de>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <stable@kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Sep 2008, Greg KH wrote:

> On Mon, Sep 08, 2008 at 03:44:53PM -0400, linux-os (Dick Johnson) wrote:
>>
>> On Mon, 8 Sep 2008, Greg KH wrote:
>>
>>> We (the -stable team) are announcing the release of the 2.6.25.17
>>> kernel.
>> [SNIPPED...]
>>
>> I have a dual AMD Dell that I installed 2.6.25.17 into. It
>> produces severe FS corruption on a Serial ATA drive if I
>> build a kernel on it. I can build the kernel on one of my
>> SCSI drives with no problems.
>
> Is this something new with 2.6.25.17, or has it always been the same for
> all 2.6.25 kernels?
>
> thanks,
>
> greg k-h
>

The previous kernel I used was linux-2.6.22.1  and this kernel doesn't
have the problem. I discovered the problem when I built and installed
the "latest stable" 2.6.25.17. My main working disk, a new SATA,
showed severe errors during each reboot. I can duplicate this at
will and remove the errors by removing my second CPU!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.48 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
