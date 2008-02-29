Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbYB2PII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbYB2PII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbYB2PHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:07:40 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2831 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528AbYB2PHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:07:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 29 Feb 2008 15:07:06.0092 (UTC) FILETIME=[BF5092C0:01C87AE4]
Content-class: urn:content-classes:message
Subject: 64-bit sources
Date: Fri, 29 Feb 2008 10:07:05 -0500
Message-ID: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit sources
Thread-Index: Ach65L9tldfgwpCzQdCthfmClG9WTQ==
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

I inherited a problem with linux-2.6.11-1.1369_FC4smp in
that plugging in a USB mouse on a new AMD machine causes
a crash. I took a new disk and installed the complete
installation from "Fedora core." The sources provided
with the distribution do not compile with the tools
provided with the distribution! I need to find the
real sources for this kernel, something that will
compile so I can add some debugging info in the
ohci-hcd driver.

Checking the web only shows a ".rpm" that contains
only patches, no source. What goes? Is this a secret
distribution?


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
