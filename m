Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYI1Hed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYI1Hed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 03:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYI1HeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 03:34:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:7443 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYI1HeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 03:34:25 -0400
X-BigFish: VPS-35(zz1432R98dR936eQ62a3L1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7WAD2-02-JMI-01
Date: Sun, 28 Sep 2008 09:33:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH] oprofile: Implement Intel architectural perfmon support
Message-ID: <20080928073301.GP23557@erda.amd.com>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org> <20080925200048.GI23557@erda.amd.com> <48DC3077.1080905@linux.intel.com> <20080926032328.GN23557@erda.amd.com> <48DD6B8E.5050106@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48DD6B8E.5050106@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 28 Sep 2008 07:33:07.0995 (UTC) FILETIME=[73B7CEB0:01C9213C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.09.08 16:09:02, Andi Kleen wrote:
> Robert Richter wrote:
>
>> I think this would be the best solution, providing a parameter
>>  oprofile.force_pmu=<oprofile arch string>
>> This can easily be implemented and also reused by others. I would be
>> fine with this solution. No separate patch needed then.
>
> Ok I can implement that, but it'll be a separate patch. Might be until
> next week that I can work on it though.

Thanks Andi,

-Robert

>
> -Andi
>
>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

