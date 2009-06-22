Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZFVWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZFVWB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFVWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:01:16 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:7304 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFVWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:01:15 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1431J98dRzz1202hzzz2fh6bh17ch61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A3FFF17.9020701@am.sony.com>
Date: Mon, 22 Jun 2009 15:00:55 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Chris Simmonds <chris@2net.co.uk>, Arnd Bergmann <arnd@arndb.de>,
       Marco <marco.stornelli@gmail.com>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de> <4A3FDBFE.8050509@2net.co.uk> <20090622203034.GA12587@uranus.ravnborg.org>
In-Reply-To: <20090622203034.GA12587@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 22:00:56.0726 (UTC) FILETIME=[EB64E360:01C9F384]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> It is not that we are talking big and complex stuff here.

I agree completely.

> pramfs is likely to be used for small things and then having to
> fix endian on a few headers in the on-dsk format does not matter.

I agree with this, but mostly out of exhaustion.

> Not compared to the potential disadvantages.

I can see no potential disadvantages.


> It should be possible to read a file-system on your x86 64bit
> box that you wrote with your small powerpc target.
For a (NV)RAM-based filesystem??  WTH???

This is not my file system, so I don't have a dog in this
fight.  I just wanted to clarify what I thought were some
misconceptions about the use cases and priorities for the
FS.  My "advocacy" may be interfering with understanding
this system and its purpose.  I'll be quiet now.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

