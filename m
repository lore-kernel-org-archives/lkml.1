Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXDQPGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXDQPGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXDQPGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:06:30 -0400
Received: from colargol.tihlde.org ([158.38.48.10]:47796 "EHLO
	colargol.tihlde.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXDQPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:06:28 -0400
X-Greylist: delayed 2848 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 11:06:28 EDT
Message-ID: <4624D71D.5040309@tihlde.org>
Date: Tue, 17 Apr 2007 16:18:05 +0200
From: =?UTF-8?B?RXNwZW4gRmplbGx2w6ZyIE9sc2Vu?= <espenfo@tihlde.org>
User-Agent: Thunderbird 2.0.0.0pre (Windows/20070415)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Drift@tihlde" <drift@tihlde.org>, espen@oxygen.tihlde.org,
       linux-kernel@vger.kernel.org
References: <4620EC23.4010404@mrfjo.org> <20070417145618.624430d9@the-village.bc.nu>
In-Reply-To: <20070417145618.624430d9@the-village.bc.nu>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 129.241.123.213
X-SA-Exim-Mail-From: espenfo@tihlde.org
Subject: Re: Machine Check Exception on Opteron 265
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on oxygen.tihlde.org)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 14 Apr 2007 16:58:43 +0200
> Espen Fjellvær Olsen <espen@oxygen.tihlde.org> wrote:
>
>   
>> Hi!
>> Today our Opteron 265, 2x2, paniced after many months uptime, giving
>> only this error message:
>>
>> HARDWARE ERROR
>> CPU 2: Machine Check Exception:            4 Bank 4: b60a200100000813
>> TSC 6bb9fd0142921a ADDR a891e9b8
>> This is not a software problem!
>>     
*snip*
> Consult your hardware vendor but if its a single event in a year it might
> be anything - even cosmic rays.
>   
Yeah, we have had more crashes now, and have removed some of our DIMMs
in hope of getting a stable system again.
And ofcourse running memtest on those DIMMs. Hope it is one of those,
and not one the CPUs =)

-- 
Mvh
Espen Fjellvær Olsen
Drift @ Tihlde
espenfo@tihlde.org

