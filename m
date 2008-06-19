Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYFSHJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYFSHJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYFSHJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:09:31 -0400
Received: from mga10.intel.com ([192.55.52.92]:5546 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbYFSHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,671,1204531200"; 
   d="scan'208";a="343215926"
Message-ID: <485A0622.9060000@linux.intel.com>
Date: Thu, 19 Jun 2008 00:09:22 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com> <alpine.LFD.1.10.0806182341000.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806182341000.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 19 Jun 2008, Dave Airlie wrote:
>> This is a bug in rawhide in gcc miscompiling something...
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=451068
> 
> Gaah. I should read all my email instead of wasting my time trying to 
> match up the code with what I can reproduce..
> 

unfortunately, kerneloops.org didn't pick up the link to this bug (due to the fact
that the oops in the bug was a jpeg....)... maybe one day if I'm really bored
I'll implement OCR into it ;)

sorry about wasting your time

