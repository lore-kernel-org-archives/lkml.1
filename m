Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbXJCExF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbXJCExF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXJCEwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:52:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10750 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXJCEww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:52:52 -0400
Message-ID: <47030F98.8030901@oracle.com>
Date: Tue, 02 Oct 2007 20:42:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: ak@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
References: <20071003013413.GA17717@havoc.gtf.org> <20071002192209.09b2fbda.randy.dunlap@oracle.com> <4702FEC7.3000000@garzik.org>
In-Reply-To: <4702FEC7.3000000@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Randy Dunlap wrote:
>> On Tue, 2 Oct 2007 21:34:13 -0400 Jeff Garzik wrote:
>>
>>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>> ---
>>> After having to go figure out what some of these means, I figured I
>>> would save others the trouble.
>>>
>>> Some of these are "best guess" based on a quick scan of the code, so it
>>> certainly needs a sanity review before going upstream.
>>
>> "iommu" is listed in Documentation/x86_64/boot-options.txt
>> along with more x86_64-specific boot options.
>> A few other arches do something similar...
> 
> Ah!  Well, seeing as how we already have a provision for arch-specific 
> options in kernel-parameters.txt, and some less-obscure arch-specific 
> options can be found there, I think an argument can be made for my patch :)
> 
> Nonethless, if the maintainer disagrees, they can drop this patch I 
> suppose.

or maybe during the x86 merge, we can merge the docs also...

-- 
~Randy
