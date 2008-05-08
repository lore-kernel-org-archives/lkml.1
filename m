Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbYEHQ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbYEHQ5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbYEHQ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:57:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420AbYEHQ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:57:14 -0400
Message-ID: <482330E1.80901@kernel.org>
Date: Thu, 08 May 2008 09:57:05 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       webmaster@kernel.org
Subject: Re: git.kernel.org does not list all the git trees
References: <20080507205821.GC18782@elf.ucw.cz> <48223998.2000904@kernel.org> <87bq3hoybo.fsf@saeurebad.de>
In-Reply-To: <87bq3hoybo.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> "H. Peter Anvin" <hpa@kernel.org> writes:
> 
>> Pavel Machek wrote:
>>> Hi!
>>>
>>> Go to git.kernel.org, click "owner" to sort by owner, last tree is by
>>> "Jeremy Kerr", which I don't believe is right.
>>>
>> I just tried it, and it ends with "Zach Brown".
>>
>> We have had problems with occasional truncation of the front page;
>> unfortunately we don't have enough info to discern any pattern what
>> would trigger it...
> 
> Maybe some sort of time-out?  I had this problem reproducible with a
> thin dial-up connection (general front page truncation, no matter what
> sorting.  Straight git.kernel.org).  Never again with a broader line.
> 

I have seen it with a 16 Mbps line myself, but very rarely.

	-hpa
