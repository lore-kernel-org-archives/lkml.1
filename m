Return-Path: <linux-kernel-owner+w=401wt.eu-S1751100AbZJQF2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbZJQF2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 01:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZJQF2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 01:28:00 -0400
Received: from host180-6-static.238-77-b.business.telecomitalia.it ([77.238.6.180]:38097
	"EHLO mail.onlinesubito.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbZJQF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 01:28:00 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Oct 2009 01:27:59 EDT
Message-ID: <4AD95424.70406@navynet.it>
Date: Sat, 17 Oct 2009 07:20:36 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       davem@davemloft.net, mpatocka@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [00/46] 2.6.31.5-stable review
References: <20091016171422.GA13339@kroah.com> <4AD8B41F.2070702@navynet.it> <20091016180343.GA16808@suse.de>
In-Reply-To: <20091016180343.GA16808@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: m.cetra@onlinesubito.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Oct 16, 2009 at 07:57:51PM +0200, Massimo Cetra wrote:
>   
>> Greg KH ha scritto:
>>     
>>> This is the start of the stable review cycle for the 2.6.31.5 release.
>>> There are 46 patches in this series, all will be posted as a response to
>>> this one.  If anyone has any issues with these being applied, please let
>>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>>> to add a Signed-off-by: line to the patch, please respond with it.
>>>
>>>   
>>>       
>> Please consider adding this:
>> http://lkml.org/lkml/2009/10/13/154
>>
>> and this:
>> http://lkml.org/lkml/2009/10/14/430
>>
>> which definitely makes 2.6.31 unusable for virtualization with KVM and with 
>> some block devices not supporting barriers.
>>     
>
> Do you have git commit ids for these fixes?
>
>   
No, sorry.

But maybe David Miller may help about this:
  http://lkml.org/lkml/2009/10/13/154

and the other should be this one:

  commit 52b1fd5a27c625c78373e024bf570af3c9d44a79
  Author: Mikulas Patocka <mpatocka@redhat.com>
    dm: send empty barriers to targets in dm_flush


> thanks,
>   
No, thanks for your work!

Max

