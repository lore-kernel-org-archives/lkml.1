Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYIINis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYIINis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYIINij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:38:39 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:49723 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYIINii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:38:38 -0400
Message-ID: <48C67C2E.8080000@diamondcut.com.br>
Date: Tue, 09 Sep 2008 10:37:50 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Daniel Barkalow <barkalow@iabervon.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
References: <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net> <48C57FDE.2010306@diamondcut.com.br> <alpine.LNX.1.00.0809081544410.19665@iabervon.org> <48C5EEE4.6090209@diamondcut.com.br> <20080909034255.GB1999@khazad-dum.debian.net>
In-Reply-To: <20080909034255.GB1999@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> Renato S. Yamane wrote:
>> Daniel Barkalow wrote:
>>> Renato S. Yamane wrote:
>>>> Attached a dmidecode from a Lenovo Thinkpad T61.
>>>> I have a Lenovo 3000-V200 too. You want a dmidecode from it?
>>>
>>> It's almost certainly only 3000 series that's interesting; I think they 
>>> test the Thinkpads with Linux and wouldn't ship with a quirky BIOS 
>>> there.
>>
>> Here is the dmidecode from a Lenovo 3000-V200.
>> I hope this help something.
>> Let me know if you need more info.
> 
> Well, does that box suffer either of the issues (breaks either with the
> patch or without the patch)?

I use 2.6.26 Kernel available in Debian Lenny and don't have any problem.

Best regards,
Renato
