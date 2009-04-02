Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZDBEoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZDBEoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZDBEoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:44:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48730 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZDBEoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:44:01 -0400
Message-ID: <49D44285.9070808@jp.fujitsu.com>
Date: Thu, 02 Apr 2009 13:43:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D183B0.6060306@jp.fujitsu.com> <20090401150711.GA20037@elte.hu>
In-Reply-To: <20090401150711.GA20037@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> Hi Ingo,
>>
>> Sorry, could you drop patch 1/3 and 3/3 from your -tip tree? Andi 
>> and I discussed some and agreed disabling CMCI need to be done in 
>> different way (at least parameter name).
> 
> Could you please send a patch that changes the parameter name?

Got it.
I'm going to post three patches from now, heading two for revert
and last one for re-implement.

Thanks,
H.Seto

