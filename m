Return-Path: <linux-kernel-owner+w=401wt.eu-S1422894AbXBAXee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422894AbXBAXee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422897AbXBAXee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:34:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:18808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422894AbXBAXed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:34:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,269,1167638400"; 
   d="scan'208"; a="42105648:sNHT20948841"
Message-ID: <45C27908.1000202@foo-projects.org>
Date: Thu, 01 Feb 2007 15:34:32 -0800
From: Auke Kok <sofar@foo-projects.org>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Trent Waddington <trent.waddington@gmail.com>
CC: Jon Masters <jonathan@jonmasters.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>	 <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>	 <45C2670F.5000003@jonmasters.org> <3d57814d0702011430l43c03ae1uc950339b6700f859@mail.gmail.com>
In-Reply-To: <3d57814d0702011430l43c03ae1uc950339b6700f859@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2007 23:34:32.0602 (UTC) FILETIME=[86818FA0:01C74659]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Waddington wrote:
> On 2/2/07, Jon Masters <jonathan@jonmasters.org> wrote:
>> Ok. I totally dig the *idea* here - I mean, this issue has been ongoing
>> for a long time now. But I'd like to see a few comments as to whether we
>> need a technological mechanism here to enforce the obvious. To me, it
>> just seems totally obvious (any legal comment?) that early C string
>> termination is undermining the intent of the MODULE_LICENSE tag.
> 
> I'm not a lawyer, but I can tell you exactly what a lawyer would say:
> 
>   "well, ya know, it's hard to say when it comes to these issues"
> 
> that's the answer to *any* copyright question.  :)

to me it even screams "bypassing or a digital copyright enforcement system". 
that sounds really close to "D.M.C.A. violation" :)

thank goodness I'm not a laywer...

Auke
