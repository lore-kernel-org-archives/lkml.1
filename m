Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0BOIwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:52:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43814 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0BOIv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:51:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B790A55.8070805@s5r6.in-berlin.de>
Date: Mon, 15 Feb 2010 09:48:21 +0100
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
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <4B767810.5020707@s5r6.in-berlin.de> <20100214171327.GF1578@ucw.cz> <4B7833FD.2010107@s5r6.in-berlin.de> <20100214205117.GE2453@elf.ucw.cz>
In-Reply-To: <20100214205117.GE2453@elf.ucw.cz>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2010-02-14 18:33:49, Stefan Richter wrote:
>> Seriously, getting xz support on
>> Windows is just as easy or as difficult as getting gz support.
> 
> Sorry, but I just don't think that's true.

Although it is. :-)

> No more windows systems
> here. On android, gzip is supported, xzip is not. Debian machine
> supports both, but gzip was preinstalled and I had to pull xzip. (This
> does not help either:
> 
> root@amd:~# apt-cache search xzip
> xzip - Interpreter of Infocom-format story-files

Considering that xz support is available even on niche systems like
Amiga OS and BeOS (via p7zip if not by other means) and xz-utils proper
build even on DOS, OpenVMS and other systems, how hard can it be to
obtain an xz decompressor on Android, Debian, or Ubuntu¹?  (¹About which
there was a note somewhere else in this thread that there is a conflict
between xz-utils and lzma-utils... That's basically because the former
supersede the latter.)

The name confusion between xz-utils and xzip can be avoided if you
search for the package in a package manager which shows package
categories (archivers vs. games).
-- 
Stefan Richter
-=====-==-=- --=- -====
http://arcgraph.de/sr/
