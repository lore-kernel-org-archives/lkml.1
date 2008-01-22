Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYAVJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYAVJDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYAVJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:03:36 -0500
Received: from main.gmane.org ([80.91.229.2]:37875 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbYAVJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:03:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?Si4gUGFibG8gRmVybsOhbmRleg==?= <pupeno@pupeno.com>
Subject: Re: Making a USB driver
Date: Tue, 22 Jan 2008 09:03:19 +0000
Message-ID: <fn4bgk$oi0$1@ger.gmane.org>
References: <fn2u8p$gv3$1@ger.gmane.org> <479515FF.3050705@gmail.com> <200801212313.17703.pupeno@pupeno.com> <479527C7.5000909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl-37-170.dsl.netsource.ie
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:

> On 01/22/2008 12:13 AM, J. Pablo Fernández wrote:
>> On Monday 21 January 2008 22:00:31 Jiri Slaby wrote:
>>> On 01/21/2008 09:11 PM, J. Pablo Fernández wrote:
>>>> Hello,
>>>>
>>>> I'm interested in making a driver for the Kinesis Savant Elite
>>>> Programable USB Foot Switches[1].
>>> [1]+1 says
>>> Linux, Sun and other Non Windows Platforms
>>> · Requires available USB port. Uses generic drivers provided by the
>>> operating system. Due to the heterogeneity in these platforms, we cannot
>>> guarantee compatibility with these systems. However, if your system can
>>> use any USB mouse and keyboard, it will probably work with a Savant or
>>> Savant Elite foot switch.
>>>
>>> I guess it's ordinary input device without any special driver needs.
>> 
>> It sends ordinary mouse and keyboard commands, but you need a driver to
>> program it what commands to send, and that's the part I want to cover: "
>> it can be easily reprogrammed on a Windows [and only Windows] PC to
>> perform any keyboard action or key combination."
> 
> But you didn't even mention that. Then try to search for usb ids in the
> tree and also in google.

I don't have the device. Maybe I can ask the vendor for the ids? how exactly
should I ask?

Thanks.
-- 
J. Pablo Fernández <pupeno@pupeno.com> (http://pupeno.com)

