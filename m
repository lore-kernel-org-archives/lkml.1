Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0BBTju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:39:50 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:56542 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0BBTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:39:48 -0500
Message-ID: <4B687F77.5020409@wpkg.org>
Date: Tue, 02 Feb 2010 20:39:35 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com>
In-Reply-To: <4B687EFF.8000202@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.02.2010 20:37, Justin P. Mattock wrote:
> apologize for top posting(didn't want to cut dmesg), can this be
> reproduced easily?
> if so are you able to bisect this?

I can reproduce it every week or so, with several reboots daily.

Sometimes I can reboot for a few hours in a row, and it boots up 
correctly each time.

So I doubt it's easily bisectable.


-- 
Tomasz Chmielewski
http://wpkg.org
