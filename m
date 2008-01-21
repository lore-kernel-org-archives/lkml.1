Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYAUXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYAUXQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYAUXQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:16:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:17734 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbYAUXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AexA++nCaNQ3lT/iFHrKcKEA7vr+cabW7ctNq0iGyQc4alsu5h/XgxOFL0iQgIT+N0mr0ijBHV1yupudIzrGStwEZIcExekIVycbE52zelhEpVAvzJ82gRlbRGPx6eV0GO571LxlzQmGi8FNoBy6HF8g/Xlntx01DeOtLTZ6eJ0=
Message-ID: <479527C7.5000909@gmail.com>
Date: Tue, 22 Jan 2008 00:16:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?IkouIFBhYmxvIEZlcm7DoW5kZXoi?= <pupeno@pupeno.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Making a USB driver
References: <fn2u8p$gv3$1@ger.gmane.org> <479515FF.3050705@gmail.com> <200801212313.17703.pupeno@pupeno.com>
In-Reply-To: <200801212313.17703.pupeno@pupeno.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2008 12:13 AM, J. Pablo Fernández wrote:
> On Monday 21 January 2008 22:00:31 Jiri Slaby wrote:
>> On 01/21/2008 09:11 PM, J. Pablo Fernández wrote:
>>> Hello,
>>>
>>> I'm interested in making a driver for the Kinesis Savant Elite
>>> Programable USB Foot Switches[1].
>> [1]+1 says
>> Linux, Sun and other Non Windows Platforms
>> · Requires available USB port. Uses generic drivers provided by the
>> operating system. Due to the heterogeneity in these platforms, we cannot
>> guarantee compatibility with these systems. However, if your system can use
>> any USB mouse and keyboard, it will probably work with a Savant or Savant
>> Elite foot switch.
>>
>> I guess it's ordinary input device without any special driver needs.
> 
> It sends ordinary mouse and keyboard commands, but you need a driver to 
> program it what commands to send, and that's the part I want to cover: " it 
> can be easily reprogrammed on a Windows [and only Windows] PC to perform any 
> keyboard action or key combination."

But you didn't even mention that. Then try to search for usb ids in the tree and 
also in google.
