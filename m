Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbXLQR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbXLQR14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXLQR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:27:47 -0500
Received: from powered.by.stone-is.net ([87.238.163.201]:52440 "EHLO
	vps.dupondje.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbXLQR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:27:46 -0500
Message-ID: <4766B151.6080406@dupondje.be>
Date: Mon, 17 Dec 2007 18:26:41 +0100
From: Jean-Louis Dupond <info@dupondje.be>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Zsolt Barat <zsolt@softmonsters.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: ATA bus error with external hd on esata
References: <47642D9A.4080600@softmonsters.com>	 <476434C7.6040307@softmonsters.com>	 <20071217025321.2f7507db.akpm@linux-foundation.org> <87f94c370712170909y691dc2e3rf7f23c64eff8da22@mail.gmail.com>
In-Reply-To: <87f94c370712170909y691dc2e3rf7f23c64eff8da22@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer schreef:
> On Dec 17, 2007 5:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>   
>> On Sat, 15 Dec 2007 21:10:47 +0100 Zsolt Barat <zsolt@softmonsters.com> wrote:
>>
>>     
>>> Zsolt Barat schrieb:
>>>       
>>>> hi list,
>>>>         
>> Let's cc the IDE development list.
>>
>>     
>>>> i just bought a "MyBook" called external HD with a fixed enclosure, from
>>>> WD. Connected to the SATA port i constantly get "ATA bus error" messages
>>>> in the kernel log. Is this a known issue?
>>>>
>>>>         
>
> As an FYI: I've had a lot of problems with the big prepackaged drives
> in the last 6 months even from Windows, so I would not be too quick to
> blame Linux.
>
> ie.
> I bought several 500GB / 1000GB Buffalo Drives last month with plans
> to use them from Windows via USB.
>
> I attempted to do a lot of heavy file copying to/from them.  I was
> getting a bunch of "Delayed Write Failures",
>
> I finally gave up.
>
> The 500GB drives had a single hard drive internally, so I opened the
> case, removed the drive and connected them via standalone external
> carriers I had around.  In that mode the drives worked fine (from
> Windows).  I've used both standalone eSata external carriers and
> standalone USB external carriers with these same physical drives with
> no issues.
>
> My conclusion is that the electronics in the prepackaged external
> units is just not up to the job if your doing heavy i/o.
>
> Greg
>   
Could u check the temps of the disk ? I had that error in windows also 
with to hot disks ! If temp is >50°C I would start to worry :)
