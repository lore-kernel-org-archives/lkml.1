Return-Path: <linux-kernel-owner+w=401wt.eu-S1422895AbXBHC23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422895AbXBHC23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422828AbXBHC23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:28:29 -0500
Received: from [61.48.53.82] ([61.48.53.82]:58157 "EHLO freya.yggdrasil.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422894AbXBHC23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:28:29 -0500
X-Greylist: delayed 780 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 21:28:16 EST
Date: Thu, 8 Feb 2007 10:16:52 +0800
From: "Adam J. Richter" <adam@yggdrasil.com>
Message-Id: <200702080216.l182Gql0014812@freya.yggdrasil.com>
To: adam@yggdrasil.com, patrick.ale@gmail.com
Subject: Re: hdparm for lib_pata
Cc: linux-kernel@vger.kernel.org, Stephen.Clark@seclark.us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> = Stephen Clark
>> = Adam Richter
>  = Patrick Ale

>>         Do you know if these drives were advertising less capability
>> than they were spec-ed at?  Do you recall if the IDE driver without
>> kernel arguments printed its rationale for reverting to the slower
>> setting?

[...]
>Then, after 2 hours, and resyncing RAID1 MD 1 devices, I started
>seeing things like:
>"Drive not ready"
>"DMA timeout on ..."

I was not asking about Patrick's desktop computer, which was already
established to be hardware problem that was fixed by replacing a
broken fan.  I was asking about Stephen Clark's two laptop computers,
which seemed like they might be examples of a need for user level
hdparm DMA setting, which is why I prefaced my question with the
following quotation:

>>On 2007-02-04 Stephen Clark wrote:
>>>I have had two different laptops that had to have boot time command line 
>>>overrides to get the
>>>driver to allow the hardware work at what it was spec-ed at.

Adam Richter
