Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYBOVth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYBOVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYBOVt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:49:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYBOVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xGwVeszmdgwpMdTMQBRa5ZMM1vpFY+OsjtcEaEKEMpnDGJFaQA7vaO3V+caB1UMvUAy3cZRPJESgXE9TQUipG+J4X16guLq1sCMGn4abno5IA8MqjktGXt129fMS+60XfEpgW4osxehv5zyrBlSEYV6dMEXiH47k3lPUHKCmPFg=
Message-ID: <47B608E4.5030504@gmail.com>
Date: Fri, 15 Feb 2008 22:49:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-32-config: why is pc-speaker an input device?
References: <47B601CF.9070300@tlinx.org>
In-Reply-To: <47B601CF.9070300@tlinx.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2008 10:19 PM, Linda Walsh wrote:
> I'm wondering how the generic, builtin PC-Speaker (config option
> "INPUT_PCSPKR") can be used as an input device.
> 
> If it can not be used for input, why is it under the input config section:
> 
> "Device Drivers"
> + -> "Input Device Support"
>     + -> "Miscellaneous devices"
>         + -> "PC Speaker Support"
> 
> When booting, it is "enumerated" as an input device: (from dmesg)
> 
>  input: PC Speaker as /devices/platform/pcspkr/input/input2
> 
> Just trying to figure out the rationale behind the choice...

Again :)

Search archives...
