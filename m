Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXF1Nvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXF1Nvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbXF1Nve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:51:34 -0400
Received: from mail.tmr.com ([64.65.253.246]:44480 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761281AbXF1Nvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:51:32 -0400
Message-ID: <4683BD56.7070707@tmr.com>
Date: Thu, 28 Jun 2007 09:53:26 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>	<1174610594.6598.3.camel@sli10-conroe.sh.intel.com>	<6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de>
In-Reply-To: <p731wfy5m74.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Daniel J Blueman" <daniel.blueman@gmail.com> writes:
> 
>> On 23/03/07, Shaohua Li <shaohua.li@intel.com> wrote:
>>> On Thu, 2007-03-22 at 23:45 +0000, Daniel J Blueman wrote:
>>>> Hi Shao-hua,
>>>>
>>>> Is the tool you mentioned last June [1] available for splitting up the
>>>> old firmware files to the new format (eg
>>>> /lib/firmware/intel-ucode/06-0d-06), or are updates available from
>>>> Intel (or otherwise) in this new format?
>>> Yes, we are preparing the new format data files and maybe put it into a
>>> new website. We will announce it when it's ready.
>> It's been a while; is there any sign of the ucode updates being
>> available, especially in light of the C2D/Q incorrect TLB invalidation
>> + recent ucode to fix this?
> 
> That microcode update is not needed on any recent Linux kernel; it flushes
> the TLBs in a way that is fine.
> 
Slashdot carried an article this morning saying that an error in Intel 
microcode was being fixed. However, it listed only Windows related sites 
for the "fix" download. Is this the same TLB issue? And are these really 
fixes for Windows to flush the TLB properly the way Linux does?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
