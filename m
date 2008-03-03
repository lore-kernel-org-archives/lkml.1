Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbYCCWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbYCCWNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYCCWNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:13:43 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1943 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYCCWNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:13:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 03 Mar 2008 22:10:58.0348 (UTC) FILETIME=[755C1EC0:01C87D7B]
Content-class: urn:content-classes:message
Subject: Re: 64-bit AMD panic
Date: Mon, 3 Mar 2008 17:10:53 -0500
Message-ID: <Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com>
In-Reply-To: <20080303162246.3f33ee24@cuia.boston.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit AMD panic
Thread-Index: Ach9e3WEMhkDikCVQL+Xowsu4su8Sg==
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com><alpine.DEB.1.00.0803031942040.5974@sheep.housecafe.de> <20080303162246.3f33ee24@cuia.boston.redhat.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Rik van Riel" <riel@redhat.com>
Cc: "Christian Kujau" <lists@nerdbynature.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 3 Mar 2008, Rik van Riel wrote:

> On Mon, 3 Mar 2008 19:45:52 +0100 (CET)
> Christian Kujau <lists@nerdbynature.de> wrote:
>
>> On Mon, 3 Mar 2008, linux-os (Dick Johnson) wrote:
>>> We have 64-bit production machines that use the kernel shipped with
>>> a RedHat distribution, linux-2.6.11-1.1369_FC4smp.
>>
>> Try asking on the Fedora lists or perhaps it's even in their bugzilla...
>
> It's a little late to ask support for Fedora 4.  The current released versions
> are Fedora 7 and 8; Fedora 9 is the current development version.
>
> -- 
> All Rights Reversed
>

That's the problem trying to support devices in production.
The last kernel I was able to locate for the x86_64 project
is linux-2.6.23. Its dates are from late last year so maybe
it will work!

It is now being compiled one one of the target machines.
If this works, I'll have to find the differences between
the old and the newer and patch the linux-2.6.11 because
it is a "certified" kernel, i.e., selected by the FAA and
determined to be politically correct!

I was hoping that somebody who works on these projects
would just reply with "just change the xyz mask to ...."
and it would work!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
