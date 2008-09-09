Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYIIDnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYIIDnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYIIDnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:43:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52222 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYIIDnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:43:00 -0400
X-Sasl-enc: cBEmvC4MokhcBODntz4JVINw+4NCzz6061Pq4dABq04x 1220931778
Date: Tue, 9 Sep 2008 00:42:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080909034255.GB1999@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net> <48C57FDE.2010306@diamondcut.com.br> <alpine.LNX.1.00.0809081544410.19665@iabervon.org> <48C5EEE4.6090209@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C5EEE4.6090209@diamondcut.com.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008, Renato S. Yamane wrote:
> Daniel Barkalow wrote:
>> Renato S. Yamane wrote:
>>> Henrique de Moraes Holschuh wrote:
>>>> I fell I need to warn you guys that you are likely breaking machines that
>>>> match that DMI info but have a newer BIOS, unless they use different BIOSes
>>>> (not enough data without a full dmidecode output from the other machine).
>>>
>>> dmidecode just from 3000-N100?
>>> Attached a dmidecode from a Lenovo Thinkpad T61.
>>> I have a Lenovo 3000-V200 too. You want a dmidecode from it?
>>
>> It's almost certainly only 3000 series that's interesting; I think they 
>> test the Thinkpads with Linux and wouldn't ship with a quirky BIOS 
>> there.
>
> Here is the dmidecode from a Lenovo 3000-V200.
> I hope this help something.
> Let me know if you need more info.

Well, does that box suffer either of the issues (breaks either with the
patch or without the patch)?


-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
