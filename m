Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbYAVJTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbYAVJTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYAVJTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:19:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:55460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbYAVJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZtrtO9W3JHeVH8ZrM3RqbARjxQeJnZKmqQ0CQvxm1n8rUwoN18i3w48ngzIgdJ+zM9iSZlhqTYyoO6no73NA3vqcTfwRatA8L9L8qeOcH/NlL5hD2MaASboRyZMwkZl0s+yq2y57+W5mz8DDICOq0UMWZFoh0oP4OH2+v63pTvk=
Message-ID: <4795B506.1030405@gmail.com>
Date: Tue, 22 Jan 2008 10:19:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?IkouIFBhYmxvIEZlcm7DoW5kZXoi?= <pupeno@pupeno.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Making a USB driver
References: <fn2u8p$gv3$1@ger.gmane.org> <479515FF.3050705@gmail.com> <200801212313.17703.pupeno@pupeno.com> <479527C7.5000909@gmail.com> <fn4bgk$oi0$1@ger.gmane.org>
In-Reply-To: <fn4bgk$oi0$1@ger.gmane.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usualy reply to all.

On 01/22/2008 10:03 AM, J. Pablo Fernández wrote:
> Jiri Slaby wrote:
> 
>> On 01/22/2008 12:13 AM, J. Pablo Fernández wrote:
>>> On Monday 21 January 2008 22:00:31 Jiri Slaby wrote:
>>>> On 01/21/2008 09:11 PM, J. Pablo Fernández wrote:
>>>>> Hello,
>>>>>
>>>>> I'm interested in making a driver for the Kinesis Savant Elite
>>>>> Programable USB Foot Switches[1].
>>>> [1]+1 says
>>>> Linux, Sun and other Non Windows Platforms
>>>> · Requires available USB port. Uses generic drivers provided by the
>>>> operating system. Due to the heterogeneity in these platforms, we cannot
>>>> guarantee compatibility with these systems. However, if your system can
>>>> use any USB mouse and keyboard, it will probably work with a Savant or
>>>> Savant Elite foot switch.
>>>>
>>>> I guess it's ordinary input device without any special driver needs.
>>> It sends ordinary mouse and keyboard commands, but you need a driver to
>>> program it what commands to send, and that's the part I want to cover: "
>>> it can be easily reprogrammed on a Windows [and only Windows] PC to
>>> perform any keyboard action or key combination."
>> But you didn't even mention that. Then try to search for usb ids in the
>> tree and also in google.
> 
> I don't have the device. Maybe I can ask the vendor for the ids? how exactly
> should I ask?

Ask for specification, otherwise you won't be able to write a driver anyway.
