Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYCGPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYCGPHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYCGPHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:07:30 -0500
Received: from spirit.analogic.com ([204.178.40.4]:1629 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYCGPH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:07:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Mar 2008 15:03:23.0091 (UTC) FILETIME=[63499230:01C88064]
Content-class: urn:content-classes:message
Subject: Re: What does a Kernel Error 4 mean?
Date: Fri, 7 Mar 2008 10:03:18 -0500
Message-ID: <Pine.LNX.4.61.0803071001280.23974@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0803062307170.26142@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: What does a Kernel Error 4 mean?
Thread-Index: AciAZGNmfHZg5YUJSk6vZTFMS6G2MA==
References: <521608.73353.qm@web52503.mail.re2.yahoo.com> <Pine.LNX.4.64.0803062307170.26142@fbirervta.pbzchgretzou.qr>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Marc Perkel" <mperkel@yahoo.com>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Mar 2008, Jan Engelhardt wrote:

>
> On Mar 6 2008 13:59, Marc Perkel wrote:
>>
>> What does a Kernel Error 4 mean? I'm getting this
>> running 64 bit Exim. Just trying to track it down and
>> wondering what an "Error 4" is?
>
> Full error message please.
> --

Interrupted system call?
See /usr/include/asm/errno.h. Generally, the kernel
errors are the negative of the user-mode errno values.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
