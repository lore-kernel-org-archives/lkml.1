Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0BNRfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:35:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41299 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0BNRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:35:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B7833FD.2010107@s5r6.in-berlin.de>
Date: Sun, 14 Feb 2010 18:33:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <4B767810.5020707@s5r6.in-berlin.de> <20100214171327.GF1578@ucw.cz>
In-Reply-To: <20100214171327.GF1578@ucw.cz>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2010-02-13 10:59:44, Stefan Richter wrote:
>> As a side note:  7zip, a very popular and Free archiving tool for
>> Windows, supports xz since its version 9 which is currently available as
>> a beta.  So, WRT the need to get an extra unarchiver, xz is just as
>> accessible to Windows users as gz is.
> 
> Wow, what a stretch.
> 
> There's about milion tools supporting gz for Windows, and many of them
> are out of beta...

And roughly half of this million archiving/ compression tools use 7zip's
backend library, which is just one way of getting xz support in a
Windows application.  Besides, what one project calls beta is called
dot-zero release elsewhere. :-)  Seriously, getting xz support on
Windows is just as easy or as difficult as getting gz support.
-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/
