Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYGKLVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYGKLVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYGKLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:20:58 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2273 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYGKLU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:20:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Jul 2008 11:19:15.0389 (UTC) FILETIME=[F3E196D0:01C8E347]
Content-class: urn:content-classes:message
Subject: Re: [PATCH 17/18] [GFS2] Remove support for unused and pointless flag
Date: Fri, 11 Jul 2008 07:19:14 -0400
Message-ID: <Pine.LNX.4.61.0807110714110.18083@chaos.analogic.com>
In-Reply-To: <1215771119431-git-send-email-swhiteho@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 17/18] [GFS2] Remove support for unused and pointless flag
Thread-Index: AcjjR/PrdPV6kJ6TTi+k9nZ7cVsOiQ==
References: <121577107950-git-send-email-swhiteho@redhat.com> <12157710872782-git-send-email-swhiteho@redhat.com> <1215771089769-git-send-email-swhiteho@redhat.com> <1215771091790-git-send-email-swhiteho@redhat.com> <12157710931623-git-send-email-swhiteho@redhat.com> <12157710954145-git-send-email-swhiteho@redhat.com> <12157710973601-git-send-email-swhiteho@redhat.com> <12157710983282-git-send-email-swhiteho@redhat.com> <12157711013356-git-send-email-swhiteho@redhat.com> <12157711023743-git-send-email-swhiteho@redhat.com> <12157711041157-git-send-email-swhiteho@redhat.com> <1215771106247-git-send-email-swhiteho@redhat.com> <12157711073280-git-send-email-swhiteho@redhat.com> <12157711093284-git-send-email-swhiteho@redhat.com> <12157711133727-git-send-email-swhiteho@redhat.com> <12157711153366-git-send-email-swhiteho@redhat.com> <12157711171692-git-send-email-swhiteho@redhat.com> <1215771119431-git-send-email-swhiteho@redhat.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1027-16024.006
X-TM-AS-Result: No--17.645000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Jul 2008 swhiteho@redhat.com wrote:

> From: Steven Whitehouse <swhiteho@redhat.com>
>
> The ability to mark files for direct i/o access when opened
> normally is both unused and pointless, so this patch removes
> support for that feature.
[Snipped...]

So linux is no longer going to support commercial databases?
Oracle and others need the O_DIRECT attribute. Linux can
probably igonore it, but such an open cannot fail or else
Linux gets thrown out of the commercial enterprise when
an upgrade disables an entire financial institution.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
