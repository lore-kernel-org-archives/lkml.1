Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0BSEjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 23:39:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0BSEjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 23:39:01 -0500
Message-ID: <4B7E15CB.9090100@kernel.org>
Date: Thu, 18 Feb 2010 20:38:35 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <alpine.LSU.2.01.1002190106070.1233@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1002190106070.1233@obet.zrqbmnf.qr>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Feb 2010 20:38:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 04:08 PM, Jan Engelhardt wrote:
> 
> On Friday 2010-02-12 16:21, Linus Torvalds wrote:
>> On Fri, 12 Feb 2010, Jean Delvare wrote:
>>>
>>> Maybe that's just me, but my main concern is neither download times nor
>>> decompression times. My main concern is the access time to directory
>>> indexes when browsing the kernel archive, because there are 5 entries
>>> for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
>>> This is horribly slow.
>>
>> This was actually the main reason for me personally to ask about just 
>> dropping support for .gz files - not because I care deeply about how much 
>> disk space kernel.org wastes, but because the long directory listings make 
>> it slower for me to mentally index the directory.
> 
> Can I feature-request that someone reduces the git.kernel.org frontpage?
> It's almost twice as large as the v2.6 dir index in http-delivered form,
> so you can already experience what it's like when v2.6/ grows bigger.

That's a topic for a completely different thread / audience than this,
lets try to keep this a bit more focused since we have the mirrors on
this discussion.

- John 'Warthog9' Hawley
