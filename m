Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXJCCap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXJCCap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXJCCai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:30:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34990 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbXJCCai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:30:38 -0400
Message-ID: <4702FEC7.3000000@garzik.org>
Date: Tue, 02 Oct 2007 22:30:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: ak@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
References: <20071003013413.GA17717@havoc.gtf.org> <20071002192209.09b2fbda.randy.dunlap@oracle.com>
In-Reply-To: <20071002192209.09b2fbda.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 2 Oct 2007 21:34:13 -0400 Jeff Garzik wrote:
> 
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>> After having to go figure out what some of these means, I figured I
>> would save others the trouble.
>>
>> Some of these are "best guess" based on a quick scan of the code, so it
>> certainly needs a sanity review before going upstream.
> 
> "iommu" is listed in Documentation/x86_64/boot-options.txt
> along with more x86_64-specific boot options.
> A few other arches do something similar...

Ah!  Well, seeing as how we already have a provision for arch-specific 
options in kernel-parameters.txt, and some less-obscure arch-specific 
options can be found there, I think an argument can be made for my patch :)

Nonethless, if the maintainer disagrees, they can drop this patch I suppose.

	Jeff



