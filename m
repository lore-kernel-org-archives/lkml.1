Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbXAaBdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbXAaBdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbXAaBdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:33:42 -0500
Received: from rtr.ca ([64.26.128.89]:1927 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbXAaBdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:33:42 -0500
Message-ID: <45BFF1F4.3060401@rtr.ca>
Date: Tue, 30 Jan 2007 20:33:40 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Bron Gondwana <brong@fastmail.fm>, Mike Houston <mikeserv@bmts.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: How many people are using 2.6.16?
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de>
In-Reply-To: <20070130203933.GJ3754@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Jan 30, 2007 at 09:13:00AM +1100, Bron Gondwana wrote:
>> We do a lot of Cyrus which does a lot of MMAP - and we also use the 
>> Areca driver - which are both strong reasons to move to 2.6.19.2, but
>> if the MMAP fix was ported back to 2.6.16 we might consider staying
>> there instead.
> 
> Please correct me if I'm wrong, but as far as I understand the problem
> the mmap bug was introduced in 2.6.19.

I believe our featherless leader said he though it was an ancient bug,
exasperated by something that went into 2.6.19.

If Linus's opinion is correct (still?), then the bug exists in all
kernels since somewhere back in the 2.4.xx days.

Linus?
