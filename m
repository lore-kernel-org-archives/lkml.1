Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbXJCQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbXJCQ74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXJCQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:59:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbXJCQ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:59:48 -0400
Message-ID: <4703CA28.9010609@redhat.com>
Date: Wed, 03 Oct 2007 12:58:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       ak@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
References: <20071003013413.GA17717@havoc.gtf.org>	<20071002192209.09b2fbda.randy.dunlap@oracle.com>	<4702FEC7.3000000@garzik.org> <20071002210125.85b84add.randy.dunlap@oracle.com> <4703161E.8040603@zytor.com>
In-Reply-To: <4703161E.8040603@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2007 12:10 AM, H. Peter Anvin wrote:
> Randy Dunlap wrote:
>>
>> Maybe we can/should merge the doc files along with the x86 arch merge.
>>
> 
> Well, the x86 merge is pretty much mechanical.  It should be followed up
> with a lot of manual merging.
> 

It would be really nice if identical kernel parameters used the same names,
so people didn't waste their time trying e.g. "nolapic_timer" on x86_64
because that option fixed their problems on i386 (it's "noapictimer" in
x86_64.)
