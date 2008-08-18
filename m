Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYHRPdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYHRPdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYHRPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:32:57 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58307 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYHRPc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:32:56 -0400
X-BigFish: VPS-37(z21eWz1432R1805M179dRzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5SZ6F-02-ZCX-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning in during hotplug on 2.6.27-rc2-git5
Date: Mon, 18 Aug 2008 10:32:47 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC7C@sausexmb4.amd.com>
In-Reply-To: <200808162334.13620.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning in during hotplug on 2.6.27-rc2-git5
Thread-Index: Acj/57t4kjWOQMCERgKyu48vVMLgkABX7svw
References: <200808141753.58547.rjw@sisk.pl> <200808162128.25330.rjw@sisk.pl> <20080816201813.GA30715@kroah.com> <200808162334.13620.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Greg KH" <greg@kroah.com>
CC: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 18 Aug 2008 15:32:48.0646 (UTC) FILETIME=[AB62E260:01C90147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > My guess is that MCE does somthing that is not allowed by 
> sysfs any more.
> > 
> > Hm, sysfs hasn't changed any in 2.6.27-rcX that I know of.
> 
> Hmm.  Mark, what kind of a system is this?  Is it a 2 
> quad-core CPU system or similar ('machinecheck4' in your
> trace seems to imply something like this)?

It's a commercial Tyan 2 socket motherboard with a modified
BIOS to support Family 10h processors.  It is a dual socket
with quad-cores in it.

-Mark Langsdorf
Operating System Research Center
AMD

