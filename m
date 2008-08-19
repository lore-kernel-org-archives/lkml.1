Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYHSRC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYHSRC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYHSRCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:02:49 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21291 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYHSRCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:02:48 -0400
X-BigFish: VPS-41(z21eWz1432R1447R1805M1fa4Lzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5UY05-02-893-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Date: Tue, 19 Aug 2008 12:02:35 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC8B@sausexmb4.amd.com>
In-Reply-To: <200808191903.30437.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Thread-Index: AckCHRXAzgSKT2yWSrSmHol8PD3ybAAADSDA
References: <200808092321.16711.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com> <200808191903.30437.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Jones" <davej@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, <kernel-testers@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Arnold, Frank" <Frank.Arnold@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 17:02:38.0115 (UTC) FILETIME=[622C5730:01C9021D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > It is sufficient to revert commit 
> > > 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0 to
> > > make things work again.
> > 
> > Thanks for the clear report.  I'll look into it and try to fix it.
> 
> Any news?

Revert the patch for now.  I'm still looking into getting 
a reliable reproduction and I do not have a fix at this time.

-Mark Langsdorf
Operating System Research Center
AMD

