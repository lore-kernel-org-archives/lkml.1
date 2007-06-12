Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbXFLMqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbXFLMqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXFLMp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:45:56 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23839 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXFLMpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:45:55 -0400
Message-ID: <466E8A5B.4080205@msgid.tls.msk.ru>
Date: Tue, 12 Jun 2007 15:58:19 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Wander Winkelhorst <w.winkelhorst@gmail.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru> <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com>
In-Reply-To: <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wander Winkelhorst wrote:
> On 6/12/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> I bought a VIA PC2500 board a few days ago - this
>> new series of their mobos,
>>
>> This beast looks nice - after replacing their cooling
>> system (that had a small fan on it) with larger but
>> fanless, -- it becomes a almost real PC (1500MHz CPU),
>> equipped with quite nice crypto and multimedia abilities,
>> but with very low power consumption and very quiet.
>>
>> But the thing is - it doesn't quite work.
> 
> Try disabling CPU frequency scaling, VIA CPU's often have problems
> with changing their frequency.

Hmm.  I wonder how to *enable* it in the first place.. ;)
e_powersaver.ko and acpi_cpufreq gives "No such device"

> Furthermore, did you do any testing of the board before you took the
> fan off? Was it stable then?

The thing is that I didn't even try to test it WITHOUT the fan.
It makes no difference in themperature (lm_sensors shows 40
degrees celsius under continious run of `openssl speed' with
fan, and 39 degrees without fan but with larger headstick).

But all the testing are done with the original headstick+fan
as provided by VIA.

/mjt

