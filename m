Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0BMWgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:36:11 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:39764 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab0BMWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:36:10 -0500
Message-ID: <4B7729B5.4040609@lougher.demon.co.uk>
Date: Sat, 13 Feb 2010 22:37:41 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<4B75A5CF.70308@lougher.demon.co.uk>	<20100212203209.0cb8afc3@hyperion.delvare>	<4B75B2A6.5080006@lougher.demon.co.uk>	<20100212225923.36a67112@hyperion.delvare>	<4B75E6C7.5030106@lougher.demon.co.uk> <20100213083115.5cf8d4a4@hyperion.delvare>
In-Reply-To: <20100213083115.5cf8d4a4@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 12 Feb 2010 23:39:51 +0000, Phillip Lougher wrote:
>> Jean Delvare wrote:
>>> Prove it. Many people out there are still working on older trees. I am
>>> working on 2.6.5 and 2.6.16 kernels on a weekly basis. If ketchup or
>>> other tools break for these trees only and not more recent ones, that
>>> won't help me at all, I will still have to update them.
>> Why are you still working on 2.6.5 and 2.6.16 kernels on a weekly
>> basis?
> 
> Because I am doing support for enterprise customers who are using
> distributions based on these kernel versions. These are SLE 9 and SLE
> 10, to name them, but RHEL supporters are in the same situation. And
> I've heard embedded developers report many times that they had to stick
> to older 2.6.x kernels too for various reasons. Not everyone is using a
> recent 2.6.x kernel, which makes it hard to draw a line between what
> should be considered old ones and what should be considered new ones.
> 

Embedded and enterprise distro users are usually stuck on ancient kernels that
were downloaded from kernel.org and patched *years ago*.  The reason they're
stuck on them is due to local modifications, and so they're not going to be
downloading ancient vanilla kernels from kernel.org now.

Phillip

