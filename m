Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbYEHRZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbYEHRZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbYEHRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:25:16 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:55786 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbYEHRZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:25:14 -0400
Message-ID: <48233747.1030605@bakke.com>
Date: Thu, 08 May 2008 19:24:23 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>
Subject: Re: [PATCH] fix apple alu keyboard with numpad
References: <4814612F.5030606@bakke.com> <20080506125406.dc047710.akpm@linux-foundation.org> <Pine.LNX.4.64.0805062244130.11363@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805062244130.11363@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote, On 05/06/2008 10:46 PM:
> On Tue, 6 May 2008, Andrew Morton wrote:
> 
>>> The nice apple alu keyboards with numpads are pretty much unusable in
>>> vanilla 2.6.25.
>>> (http://images.apple.com/keyboard/images/gallery/wired_1_20070813.jpg)
>>> Hitting the 'clear' key (=numlock) disables the numpad, and maps multiple
>>> alphanumeric keys to numpad symbols in typical laptopkeyboard fashion.
>> This conflicts rather directly with 
>> hid-disable-numlock-emulation-for-apple-aluminium-keyboards.patch below 
>> (hm, seems we didn't get a changelog for that one).
> 
> Hi,
> 
> I have just today applied Diego's patch into my tree [1], he has provided 
> the changelog out of list to me.
> 
>> Jiri, what should we do here?
> 
> Dag, I think Diego's patch should solve the issue you are seeing, right?
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commit;h=ffe6f7b799e33f51732520979f9c253a252b9d5e

I'll give it a shot and let you know.

Dag B
