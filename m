Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXK1PjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXK1PjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbXK1PjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:39:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63432 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbXK1PjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:39:09 -0500
Message-ID: <474D8B83.9050609@oracle.com>
Date: Wed, 28 Nov 2007 07:38:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Wagner Ferenc <wferi@niif.hu>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] Remove trailing NULs from network bonding sysfs interface.
References: <871wabkxcd.fsf@szonett.ki.iif.hu>	<20071127194929.757e4ebe.randy.dunlap@oracle.com> <87bq9ekb8m.fsf@szonett.ki.iif.hu>
In-Reply-To: <87bq9ekb8m.fsf@szonett.ki.iif.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wagner Ferenc wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>> On Wed, 28 Nov 2007 01:49:54 +0100 =?utf-8?q?Ferenc_W=C3=A1gner?= wrote:
>>
>> Patches 1 & 3 use
>>
>> 	if (res) statement;
>>
>> but the preferred form is
>>
>> 	if (res)
>> 		statement;
>>
>> Even if this style was already used in the source file, it should
>> be cleaned up.
> 
> No principal problem.  So that I learn something useful: how should I
> go about this?  I created the patches with git-format-patch, and they
> depend on each other, so I'd rather not git-reset, if possible...
> 
> Can I just create a follow-up patch which fixes this stylistic issue?

That's OK with me.  I can't say how it might be done with git.

Thanks,
-- 
~Randy
