Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZAUR5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZAUR5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZAUR4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:56:50 -0500
Received: from mail91.analogic.com ([12.187.86.31]:41178 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbZAUR4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:56:50 -0500
X-AuditID: 0a770115-a7afabb000000e5e-85-497761e118b2
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Jan 2009 17:56:28.0180 (UTC) FILETIME=[95786540:01C97BF1]
Content-class: urn:content-classes:message
Subject: Re: Getting out-of-kernel modules compiled
Date: Wed, 21 Jan 2009 12:56:28 -0500
Message-ID: <Pine.LNX.4.61.0901211255340.16847@chaos.analogic.com>
In-Reply-To: <20090121172248.GA3661@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Getting out-of-kernel modules compiled
Thread-Index: Acl78ZWeX752HEjpTgKtELKyP9bAZQ==
References: <Pine.LNX.4.61.0901211052020.16591@chaos.analogic.com> <20090121172248.GA3661@uranus.ravnborg.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009, Sam Ravnborg wrote:
[SNIPPED...]

> dick-y := rtc.o rtc_hwr.o
>
> This will properly build rtc_hwr.S => rtc_hwr.o
>
> 	Sam
>
Yes, thanks. It works!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4784.32 BogoMips).
My book : http://www.AbominableFirebug.com/
.


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
