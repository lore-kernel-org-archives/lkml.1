Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYE3WgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYE3WgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYE3Wf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:35:59 -0400
Received: from mga06.intel.com ([134.134.136.21]:43907 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869AbYE3Wf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,568,1204531200"; 
   d="scan'208";a="388822411"
Message-ID: <48408150.5030501@linux.intel.com>
Date: Fri, 30 May 2008 15:36:00 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
References: <48402DAA.60202@linux.intel.com> <ef1cd66f0805301534t2dca0f4eh97dac71e10d3d683@mail.gmail.com>
In-Reply-To: <ef1cd66f0805301534t2dca0f4eh97dac71e10d3d683@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Voß wrote:
> Hi Arjan,
> 
> 2008/5/30 Arjan van de Ven <arjan@linux.intel.com>:
>> Rank 2: sysfs_add_one (warning)
>>        Reported 243 times (759 total reports)
> [...]
>> Rank 3: mark_buffer_dirty (warning)
>>        Reported 222 times (759 total reports)
> 
> It seems like a strange coincidence that the first two entries have
> the same number of total reports.  Is this really the case or is there
> something mixed up?

coincidence; I just recreated a new version of the report (so several hours later) and they're 1 appart now.
