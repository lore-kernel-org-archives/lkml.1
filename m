Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752169AbYLRIdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbYLRIdE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLRIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:32:50 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:18908 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbYLRIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:32:49 -0500
Message-ID: <494A0AAB.6070906@panasas.com>
Date: Thu, 18 Dec 2008 10:32:43 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] exofs: Documentation
References: <4947BFAA.4030208@panasas.com> <4947CB0C.3000406@panasas.com> <20081218074714.GC2110@ucw.cz>
In-Reply-To: <20081218074714.GC2110@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 08:32:47.0036 (UTC) FILETIME=[3473DFC0:01C960EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> Added some documentation in exofs.txt, as well as a BUGS file.
>>
>> For further reading, operation instructions, example scripts
>> and up to date infomation and code please see:
>> http://open-osd.org
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
>> +===============================================================================
>> +WHAT IS EXOFS?
>> +===============================================================================
>> +
>> +exofs is a file system that uses an OSD and exports the API of a normal Linux
>> +file system. Users access exofs like any other local file system, and exofs
>> +will in turn issue commands to the local initiator.
>> +
> 
> Which tells me pretty much nothing. I guess it should explain what is
> OSD... there are way too many TLAs and ETLAs in FOSS world.
> 								Pavel

Thanks, you are completely right. I need to give a short description
and point to the osd.txt file that was added in the prerequisite patchset

will do
