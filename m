Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYGWTc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYGWTc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYGWTcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:32:19 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4290 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYGWTcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:32:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 23 Jul 2008 19:30:00.0463 (UTC) FILETIME=[7F7851F0:01C8ECFA]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] x86: apic: Changing export symbols to *_GPL
Date: Wed, 23 Jul 2008 15:29:59 -0400
Message-ID: <Pine.LNX.4.61.0807231525490.30326@chaos.analogic.com>
In-Reply-To: <20080723184709.ECF218403@erda.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: apic: Changing export symbols to *_GPL
Thread-Index: Acjs+n+VEyEbBCIcRt6zALb56l6Jfw==
References: <20080722125315.5d34f2e6@infradead.org> <20080723184709.ECF218403@erda.amd.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1027-16050.001
X-TM-AS-Result: No--1.236000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jul 2008, Robert Richter wrote:

> This fits better here.

[Snipped...]
This question was raised before and simply dismissed.

If somebody wrote a procedure in the kernel that exported
some symbols. And that person wanted anybody to use that
symbol, upon what authority does one change "EXPORT_SYMBOL"
to "EXPORT_SYMBOL_GPL?" This will need to eventually be
answered.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
