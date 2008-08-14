Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYHNQHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYHNQHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNQGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:06:52 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:46949 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYHNQGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:06:51 -0400
X-BigFish: VPS-48(z21eWz1432R98dR1805M936fQzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5LM2Z-01-ZBS-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning in during hotplug on 2.6.27-rc2-git5
Date: Thu, 14 Aug 2008 11:06:42 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC6F@sausexmb4.amd.com>
In-Reply-To: <200808141753.58547.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning in during hotplug on 2.6.27-rc2-git5
Thread-Index: Acj+JZkqLFz8PjxaQdqhSCwpkepxHgAAhLdw
References: <200808121700.20369.mark.langsdorf@amd.com> <200808141753.58547.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Andi Kleen" <andi@firstfloor.org>
CC: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Aug 2008 16:06:43.0151 (UTC) FILETIME=[BE64B5F0:01C8FE27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday, 13 of August 2008, Mark Langsdorf wrote:
> > I'm seeing the following error message when I hotunplug and replug
> > a cpu in 2.6.27-rc2-git5.  The system becomes unstable almost
> > immediately afterwards.
> 
> Hm, it seems that MCE is involved somehow.  Andi, can you 
> have a look at this, please?

Disabling MCE did eliminate the error message.

-Mark Langsdorf
Operating System Research Center
AMD

