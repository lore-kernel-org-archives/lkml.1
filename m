Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0BNSl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:41:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41602 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0BNSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:41:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B784378.8070309@s5r6.in-berlin.de>
Date: Sun, 14 Feb 2010 19:39:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jean Delvare <khali@linux-fr.org>, Willy Tarreau <w@1wt.eu>,
       mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <20100214170724.GE1578@ucw.cz>
In-Reply-To: <20100214170724.GE1578@ucw.cz>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
[Jean Delvare wrote]
>> I have an old, slow machine here which I am going to use to perform
>> some real world testing, and I'll post the results when I'm done. But I
>> suspect that building a kernel on this machine, even a small one with
>> just the drivers it needs, will take much longer than unpacking the
>> sources. So anyone worrying about performance would rather rely on
>> cross-compilation, and in turn can afford whatever decompression tool
>> is needed.
> 
> On zaurus, kernel compilation takes 4 hours. (I.e. "one night"). So
> that one is ... well ... done overnight.
> 
> Untar is something I normally wait for, since you need to run
> (interactive) oldconfig after that.

If the download takes m minutes and unpacking and unarchiving tar.gz
takes another n minutes, what difference does it make for this workflow
when instead m + p minutes are spent for download + unpacking and
unarchiving tar.bz2 or tar.xz?
-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/
