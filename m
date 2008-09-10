Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYIJHpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYIJHpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYIJHpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:45:25 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:48217 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYIJHpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:45:24 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :KUEFfEyIfvurJj9T/C45bJjugCcRcpKspBzHGHUPkpqEWZN2yWOZpp3GaYwY8+WWOHoNjD4=
Message-ID: <48C77AA6.7050702@edgar-kalkowski.de>
Date: Wed, 10 Sep 2008 09:43:34 +0200
From: Edgar Kalkowski <eMail@edgar-kalkowski.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: PROBLEM: Kernel 2.6.26 oops if I unplug my Logitech USB 1.1 headset
References: <48C069B1.3000201@edgar-kalkowski.de>	<20080904172822.e5390a59.akpm@linux-foundation.org> <s5hod33t6f9.wl%tiwai@suse.de>
In-Reply-To: <s5hod33t6f9.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://www.edgar-kalkowski.de/gpg.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that it lasted a while, I had to compile a 2.6.25 kernel. But the error is
just the same with it. The funny thing is that it does not happen always but
only sometimes (I have to unplug and replug about 5 times until the error
occurrs). Looks to me like a threading issue if I may dare to guess. ;)

Regards!

Edgar


Takashi Iwai wrote:
> At Thu, 4 Sep 2008 17:28:22 -0700,
> Andrew Morton wrote:
>> On Fri, 05 Sep 2008 01:05:21 +0200
>> Edgar Kalkowski <eMail@edgar-kalkowski.de> wrote:
>>
>>> Dear kernel hackers. ;)
>>>
>>> [1.] One line summary of the problem: If I unplug my USB-Headset the kernel oopses.
>> cc's added.
>>
>> Might be USB, might be ALSA.
> 
> Hm, it's hard to guess...
> Edgar, could you check whether it happens with 2.6.25?
> 
> 
> thanks,
> 
> Takashi
> 
