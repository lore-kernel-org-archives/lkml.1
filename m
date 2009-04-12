Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZDLSvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZDLSvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZDLSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:51:11 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:40177 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbZDLSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:51:11 -0400
Message-ID: <49E23811.2090409@solemnwarning.net>
Date: Sun, 12 Apr 2009 19:50:57 +0100
From: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 /proc/diskstats
References: <49E13D18.2090805@solemnwarning.net>
In-Reply-To: <49E13D18.2090805@solemnwarning.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=4J9GnK0NU8PFg4qgppoA:9 a=kKvcYj5bcSaVLlTebiAA:7 a=M2UmFvomYaTM5H23t7fau_b5Y1oA:4 a=eZLSmJVMEtUA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting since I don't think anyone will see it ~150 messages down, 
sorry if this is the wrong way to draw attention to a bug.

Daniel Collins wrote:
> Hi
>
> Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only 
> after access/mount. It is visible in /sys/block/ from boot, so there 
> are no issues detecting it. This may also affect other devices such as 
> hda but I haven't tested this yet, my test system and QEMU both only 
> have ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same 
> behavior. Is this a bug or a deliberate change?
>
> Thanks
