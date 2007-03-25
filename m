Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbXCYLwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbXCYLwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXCYLwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:52:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:58169 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXCYLwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=nxvSnB8HhIWb+0kANike91ri6hrsyP221vhrehi8dzXVvfIhZB+oPQmicWd+Snwvjkq7tKnfgOb/DOPmpgeb54L0vzU06Vc1MNVlVvsYJ2mfRuzvhOcgLll2PcDbd1jxBU209kOGV6XEHq5bRqP1hlerUjwWYWxxL/pO9s50G5Y=
Message-ID: <46066287.6020005@googlemail.com>
Date: Sun, 25 Mar 2007 13:52:39 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, michal.k.k.piotrowski@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-03-24-00-14.tar.gz uploaded
References: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>	<6bffcb0e0703241018h6761df0oe3a7dea0bab8be78@mail.gmail.com>	<20070324101653.602d9a79.akpm@linux-foundation.org> <20070324.123613.130229822.davem@davemloft.net>
In-Reply-To: <20070324.123613.130229822.davem@davemloft.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller napisał(a):
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Sat, 24 Mar 2007 10:16:53 -0800
> 
>> On Sat, 24 Mar 2007 18:18:42 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>>
>>> On 24/03/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>>>> The mm snapshot broken-out-2007-03-24-00-14.tar.gz has been uploaded to
>>>>
>>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-24-00-14.tar.gz
>>>>
>>> My network doesn't work
>>> "RTNETLINK answers: Invalid argument"
>>>
>>> git-net* patches?
>>>
>> There's a huge collision between git-net and git-wireless which I haven't
>> started to look at yet.  I suggest you forget about that particular
>> snapshot.
> 
> We fixed that bug about a day after you likely took a snapshot
> of the net-2.6.22 tree.
> 
> Here is the fix:
> 

Problem fixed, thanks.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
