Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0BAUS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:18:28 -0500
Received: from mail.lang.hm ([64.81.33.126]:56326 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab0BAUS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:18:26 -0500
Date: Mon, 1 Feb 2010 12:17:41 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Witold Sowa <witold.sowa@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
Subject: Re: Linux wireless GSoC 2010 project ideas
In-Reply-To: <1265055284.26421.16.camel@maxim-laptop>
Message-ID: <alpine.DEB.2.00.1002011216040.7748@asgard.lang.hm>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>  <4B65F024.3080505@gmail.com> <1264972854.3597.17.camel@johannes.local>  <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com> <1265055284.26421.16.camel@maxim-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Maxim Levitsky wrote:

> On Mon, 2010-02-01 at 10:01 -0800, Luis R. Rodriguez wrote:
>> On Sun, Jan 31, 2010 at 1:20 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Sun, 2010-01-31 at 22:03 +0100, Witold Sowa wrote:
>>>
>>>> Some time ago johill asked me if I would be interested in hacking on
>>>> adding WPS support to NetworkManager. Well, I would but I don't know
>>>> when I'll find some time for that. I don't know how much of work would
>>>> it require, but it possibly could be a topic of one of GSoC 2010
>>>> projects. I have no idea know if anybody would be willing to be a mentor
>>>> for such a project.
>>>
>>> Sounds like a good project to me, but I don't think I'd be a good mentor
>>> for since I'm not familiar with the NM codebase at all. As for how much
>>> work it would require, I think the basic client-side functionality could
>>> possibly be "too simple" for you, WPS has a lot of additional
>>> functionality (e.g. WPS support for the AP side).
>>
>> In case it helps, I believe all that would be required is the dbus
>> stuff, there are sample GUI examples of this already provided through
>> the wpa_supplicant wpa_gui.
>
> Here are couple of ideas (I don't think I will enter the program
> though):
>
> 1 - Make Ad-Hoc WPA networks work (with NM). This would involve changes
> in kernel, but I don't think will involve changes in hardware drivers.
>
> 2 - Allow a wireless card to associate to several APs at once (if they
> share the frequency).
> Implement this at least for ath5/9k. Madwifi had that feature. Maybe
> ath9k has. If it has that feature, test it.
> Implement proper GUI support in NM for that.

why would you want to do this?

> 3 - Create wardriving^Wwireless analysis tool.
> No, not for wardriving. I mean an application that shows and analyzes
> nicely the signal strength of nearby APs, and other features of it

it seems to me that kismet provides exactly this capability, what is it 
missing?

David Lang
