Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab0BYCsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:48:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:55697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840Ab0BYCsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:48:18 -0500
Message-ID: <4B85E745.2000904@kernel.org>
Date: Thu, 25 Feb 2010 11:58:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: hancockrwd@gmail.com, david-b@pacbell.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>	 <201002192139.46189.david-b@pacbell.net>	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>	 <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl> <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>,<4B85E038.20905@kernel.org> <SNT125-W228B049D3934AC288355D8C3400@phx.gbl>
In-Reply-To: <SNT125-W228B049D3934AC288355D8C3400@phx.gbl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 02:48:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 11:41 AM, Yuhong Bao wrote:
> 
>> gained. There just isn't much point in trying to enable a shiny new
>> feature on an aging platform or technology. 
> You mean we should focus on enabling 64-bit DMA for USB 3.0 (xHCI)?

Yeah, probably, in this context, but I was just making a general
statement.  Trying out a new feature which hasn't been used widely on
old things doesn't go too well in many cases - the hw vendor and BIOS
writer already moved on, people end up experiencing regressions on
configurations which used to work fine and when that happens, new
comers try out and find out it's broken in strange ways and when that
happens they're much less likely to bother reporting and trying to get
the problem fixed.  And, most importantly, when things aren't used
widely, that usually is for a reason - it just doesn't make that much
of a difference.

Thanks.

-- 
tejun
