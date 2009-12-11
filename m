Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbZLKWHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbZLKWHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZLKWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:07:04 -0500
Received: from lo.gmane.org ([80.91.229.12]:53664 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760921AbZLKWHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:07:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Fri, 11 Dec 2009 17:06:12 -0500
Message-ID: <hfufos$1uj$1@ger.gmane.org>
References: <200912111124.18118.kernel@kolivas.org> <alpine.DEB.2.00.0912110809320.32415@router.home> <200912120204.51547.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-72-92-176-205.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
In-Reply-To: <200912120204.51547.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
>> Could you make the scheduler build time configurable instead of replacing
>> the existing one? Embedded folks in particular may love a low footprint
>> scheduler.
>>
> 
> It's not a bad idea, but the kernel still needs to be patched either way. To 
> get BFS they'd need to patch the kernel. If they didn't want BFS, they 
> wouldn't patch it in the first place.
> 
The advantage would be that the same kernel source could then be built into a 
custom version with only the config changed.Since building with various configs 
is hardly unusual it would save some carrying of multiple sources, for those who 
build for several uses already.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

