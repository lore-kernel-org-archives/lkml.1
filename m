Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYH0Mxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYH0Mxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYH0Mx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:53:28 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:47496 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYH0Mx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:53:27 -0400
Message-ID: <48B54E45.6020206@aitel.hist.no>
Date: Wed, 27 Aug 2008 14:53:25 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
References: <4899AF8E.20105@sbg.ac.at> <48A43CB5.8010709@sbg.ac.at>	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>	 <48AD8125.7050104@sbg.ac.at>	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>	 <48AE90BB.5090800@aitel.hist.no>	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>	 <48B29320.5070903@aitel.hist.no>	 <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>	 <48B3CDAF.604@aitel.hist.no> <86802c440808260943k210be3edp54aebc9fea5366f5@mail.gmail.com>
In-Reply-To: <86802c440808260943k210be3edp54aebc9fea5366f5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Aug 26, 2008 at 2:32 AM, Helge Hafting
> <helge.hafting@aitel.hist.no> wrote:

>> I hope this helps so the extra bootup parameters can be avoided in the
>> release kernel.
> 
> that is a little bit hard.

Well, perhaps not 2.6.27, but I hope I won't need
"mtrr_spare_reg_nr=3" forever. Or is my machine a strange
corner case as far as mtrr's are concerned?

Helge Hafting
