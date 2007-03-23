Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXCWTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXCWTW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXCWTW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:22:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911AbXCWTW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:22:56 -0400
Message-ID: <46042906.1030100@redhat.com>
Date: Fri, 23 Mar 2007 15:22:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup during suspend
References: <20070320123253.GB19019@elf.ucw.cz>	<s5htzwgccq3.wl%tiwai@suse.de>	<46000633.5000900@redhat.com>	<s5h648vdhin.wl%tiwai@suse.de> <s5hzm67c2d9.wl%tiwai@suse.de>
In-Reply-To: <s5hzm67c2d9.wl%tiwai@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 20 Mar 2007 17:08:48 +0100,
> I wrote:
>> At Tue, 20 Mar 2007 12:05:07 -0400,
>>>
>>> http://lkml.org/lkml/2006/12/3/9
>> This is a different problem.
>> A known workaround is to provide probe_mask=1 module option.
> 
> BTW, does this happen on the latest linus git tree?  (rc4 may work,
> though)
> 

2.6.21-rc4 works perfectly, detecting my Acer notebook's model
properly and adding the sound devices to the bus. Very nice...

