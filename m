Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYHOTVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYHOTVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYHOTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:21:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11673 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbYHOTVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:21:33 -0400
X-BigFish: VPS-47(z21eWz1432R936eQ1805M936fQzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5NPRD-01-4CY-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/01][retry 5] x86: L3 cache index disable for 2.6.26
Date: Fri, 15 Aug 2008 14:21:22 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC78@sausexmb4.amd.com>
In-Reply-To: <20080815164213.GA29956@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/01][retry 5] x86: L3 cache index disable for 2.6.26
Thread-Index: Acj+9fOvxmHbsb2fTkeungpnC/6uswACzxVw
References: <200807181603.52332.mark.langsdorf@amd.com> <200808141148.38108.mark.langsdorf@amd.com> <20080814171042.GA26985@kroah.com> <200808141332.53538.mark.langsdorf@amd.com> <20080815164213.GA29956@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <greg@kroah.com>, Pavel Machek <pavel@suse.cz>,
       "Deguara, Joachim" <joachim.deguara@amd.com>, <gregkh@ucw.cz>,
       <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Aug 2008 19:21:23.0374 (UTC) FILETIME=[1AC30CE0:01C8FF0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch does not set an automatic policy to disable
> > the L3 cache.  Policy decisions would need to be made
> > by a RAS handler.  This patch merely makes it easier to
> > see what indices are currently disabled.
> 
> hm, looks good - but since i've got an earlier version of 
> this included 
> in -tip already:
> 
>  commit a24e8d36f5fc047dac9af6200322ed393f2e3175
>  Author: Mark Langsdorf <mark.langsdorf@amd.com>
>  Date:   Tue Jul 22 13:06:02 2008 -0500
> 
>     x86: L3 cache index disable for 2.6.26
> 
> could you please send a delta patch against tip/master?
> 
>    http://people.redhat.com/mingo/tip.git/README

tip/master looks likes it has the version 5 of my patch
in it already.  Am I missing something?

-Mark Langsdorf
Operating System Research Center
AMD

