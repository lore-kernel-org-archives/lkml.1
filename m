Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZIHI4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZIHI4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZIHI4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:56:39 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:53883 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZIHI4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:56:39 -0400
Message-ID: <4AA61C46.1050800@parrot.com>
Date: Tue, 8 Sep 2009 10:56:38 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: "sdhci-devel@lists.ossman.eu" <sdhci-devel@lists.ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdhci can turn off irq up to 200 ms
References: <4A4B6184.7000903@parrot.com>	<4A55C631.7030103@parrot.com>	<20090906152537.15303d69@mjolnir.ossman.eu>	<4AA4D8BA.602@parrot.com> <20090907185956.3f53440c@mjolnir.ossman.eu>
In-Reply-To: <20090907185956.3f53440c@mjolnir.ossman.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman a écrit :
> On Mon, 7 Sep 2009 11:56:10 +0200
> Matthieu CASTET <matthieu.castet@parrot.com> wrote:
> 
>> Pierre Ossman a écrit :
>>> I seem to recall having problems with jiffies not updating with those
>>> locks held (or perhaps it was when inside the isr).
>>>
>>> What arch have you been testing this on?
>> It have been tested on arm.
>>
> 
> Things might be different there. I suggest you also try to get it
> tested on x86, where this driver sees most of its use.
> 
I don't have sdhci device on x86. Can somebody on this list try it ?

Thanks

Matthieu
