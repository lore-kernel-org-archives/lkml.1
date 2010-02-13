Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0BMVma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:42:30 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:46598 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0BMVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:42:28 -0500
Date: Sat, 13 Feb 2010 12:37:07 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Avi Kivity <avi@redhat.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jean Delvare <khali@linux-fr.org>, Willy Tarreau <w@1wt.eu>,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel] Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <4B767C67.7060701@redhat.com>
Message-ID: <alpine.LNX.2.01.1002131233450.30803@filesrv1.baby-dragons.com>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu>
 <20100213091748.276821e1@hyperion.delvare> <4B767810.5020707@s5r6.in-berlin.de> <4B767C67.7060701@redhat.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Sat, 13 Feb 2010 21:37:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010, Avi Kivity wrote:

> On 02/13/2010 11:59 AM, Stefan Richter wrote:
>> Jean Delvare wrote:
...snip...
>> As a side note:  7zip, a very popular and Free archiving tool for
>> Windows, supports xz since its version 9 which is currently available as
>> a beta.  So, WRT the need to get an extra unarchiver, xz is just as
>> accessible to Windows users as gz is.
>
> Can you even unpack a kernel tree on Windows?  There are some files (e.g. 
> net/ipv4/netfilter/ipt_{ecn,ECN}.c) which conflict on a case-preserving 
> filesystem.
 	What filesystem version are you talking about ?
 	ntfs as of recent windows is not case insensitive .
 	What do you mean by , "a case-preserving filesystem" ?

 	Now whether or not the tools available are case insensitive is another 
matter .

 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
