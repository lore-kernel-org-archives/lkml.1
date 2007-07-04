Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXGDUie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXGDUie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXGDUi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:38:27 -0400
Received: from mail.trixing.net ([87.230.125.58]:54214 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbXGDUi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:38:26 -0400
Message-ID: <468C053D.9050302@l4x.org>
Date: Wed, 04 Jul 2007 22:38:21 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org> <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
In-Reply-To: <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
>> Bryan Wu wrote:
>>> Jie's patch is required because we will release our new Blackfin toolchain.
>> So, what is the new toolchain version?
>> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
> 
> we'll post new toolchain binaries in a bit

Hrm, somehow I don't understand it. On [1] you're
talking about gcc 4.1.2 and binutils 2.17 supporting
the -mcpu switch. But if you download the 2007R1 RC9
toolchain from the Files section of the site (tar.gz)
you actually get 4.1.1 without mcpu support. But the
version string from gcc indicates 07r1.
Care to explain?

Thanks,

Jan

ps: All in all it is a bit unfortunate to put features
    in the upstream kernel for a toolchain version just
    available from svn.


[1]
http://docs.blackfin.uclinux.org/doku.php?id=toolchain_release_notes_2007r1

