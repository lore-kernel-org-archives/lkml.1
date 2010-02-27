Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968241Ab0B0MzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:55:12 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:36967 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968209Ab0B0MzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:55:09 -0500
Message-ID: <4B891621.5070807@wpkg.org>
Date: Sat, 27 Feb 2010 13:54:57 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com>	 <4B687F77.5020409@wpkg.org>  <4B6885FA.80509@gmail.com> <1265963139.2484.3.camel@realization> <4B751664.8060603@gmail.com>
In-Reply-To: <4B751664.8060603@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:

> but what about 2.6.33*(hot off of the press thing).

I found a way to 100% reproduce the kernel "hang" while booting 2.6.33. 
The symptoms will look like here:

http://wpkg.org/files/i7_hang/


To hang the kernel while booting, just tap repeatedly on the keyboard as 
soon as the bootloader starts loading the kernel.

The kernel hangs for me every time as I do it.

If it matters, I use a USB keyboard (as a matter of fact, two USB 
keyboards are connected as its a multiseat PC, although I tap the keys 
on only one of them).



-- 
Tomasz Chmielewski
http://wpkg.org
