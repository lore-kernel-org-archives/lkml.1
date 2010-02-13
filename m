Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab0BMKDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:03:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35130 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0BMKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:03:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B767810.5020707@s5r6.in-berlin.de>
Date: Sat, 13 Feb 2010 10:59:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Willy Tarreau <w@1wt.eu>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>	<4B75A5DC.3060803@kernel.org>	<20100212202357.6363d5af@hyperion.delvare>	<20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare>
In-Reply-To: <20100213091748.276821e1@hyperion.delvare>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Sat, 13 Feb 2010 00:07:02 +0100, Willy Tarreau wrote:
>> Gzip is well
>> defined as a standard, it's even described in an RFC and is present
>> on almost any system (unix or not) now. Any student who wants to take
>> a look at the kernel will have access to gunzip, even from an old
>> Solaris 8 workstation or a Windows XP desktop PC.
> 
> Really? I have a Windows XP laptop at hand and it can't read .gz files.
> If I ask it to try, it tells me I should install WinZip. I also seem to
> recall that I had to install GNU gzip myself back when I was working on
> a Solaris workstation (but I might remember badly.)

As a side note:  7zip, a very popular and Free archiving tool for
Windows, supports xz since its version 9 which is currently available as
a beta.  So, WRT the need to get an extra unarchiver, xz is just as
accessible to Windows users as gz is.
-- 
Stefan Richter
-=====-==-=- --=- -==-=
http://arcgraph.de/sr/
