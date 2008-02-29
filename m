Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbYB2Q1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbYB2Q1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbYB2Q1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:27:07 -0500
Received: from spirit.analogic.com ([204.178.40.4]:3254 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbYB2Q1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:27:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 29 Feb 2008 16:26:08.0190 (UTC) FILETIME=[C9D34DE0:01C87AEF]
Content-class: urn:content-classes:message
Subject: Re: 64-bit sources
Date: Fri, 29 Feb 2008 11:25:58 -0500
Message-ID: <Pine.LNX.4.61.0802291123280.23162@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0802291631020.24056@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit sources
Thread-Index: Ach678nvcA87FCxRTYyinoucd1U5ZQ==
References: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com> <Pine.LNX.4.64.0802291631020.24056@fbirervta.pbzchgretzou.qr>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes. The RPM contains only patches and the patches won't
patch a 2.6.11 kernel either! Perhaps they need to be
in some undefined order.

On Fri, 29 Feb 2008, Jan Engelhardt wrote:
>
> On Feb 29 2008 10:07, linux-os (Dick Johnson) wrote:
>> Hello all,
>>
>> I inherited a problem with linux-2.6.11-1.1369_FC4smp in
>> that plugging in a USB mouse on a new AMD machine causes
>> a crash. I took a new disk and installed the complete
>> installation from "Fedora core." The sources provided
>> with the distribution do not compile with the tools
>> provided with the distribution! I need to find the
>> real sources for this kernel, something that will
>> compile so I can add some debugging info in the
>> ohci-hcd driver.
>>
>> Checking the web only shows a ".rpm" that contains
>> only patches, no source. What goes? Is this a secret
>> distribution?
>
> This one?
> http://ftp-stud.hs-esslingen.de/pub/fedora/linux/core/4/SRPMS/kernel-2.6.11-1.1369_FC4.src.rpm
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
