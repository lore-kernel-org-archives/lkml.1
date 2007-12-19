Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXLSVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXLSVLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXLSVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:11:11 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2574 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbXLSVLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:11:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 19 Dec 2007 21:10:39.0990 (UTC) FILETIME=[9BAB4160:01C84283]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Wed, 19 Dec 2007 16:10:39 -0500
Message-ID: <Pine.LNX.4.61.0712191608160.4660@chaos.analogic.com>
in-reply-to: <Pine.LNX.4.64.0712192142060.5524@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchCg5vFXJqg73uPS4uannPLMvdB8A==
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <Pine.LNX.4.64.0712192142060.5524@fbirervta.pbzchgretzou.qr>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Dec 2007, Jan Engelhardt wrote:

>
> On Dec 19 2007 15:10, linux-os (Dick Johnson) wrote:
>
>
>> I got rid of __init and anything else that I thought could cause the fault,
>
> I anticipate the day removing __init causes a breakage, heh.
> I mean, if all in-tree modules and LDD3 use it, it can't be wrong, can it?
>
>> plus got rid of all the code!
>> static int32_t startup()
>
> I noticed that. Where's your "void" gone? :-)

What void???


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
