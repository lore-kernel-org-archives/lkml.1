Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbYLTMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbYLTMmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 07:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYLTMmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 07:42:32 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39414 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLTMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 07:42:31 -0500
Message-ID: <494CE82E.90008@davidnewall.com>
Date: Sat, 20 Dec 2008 23:12:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Halted system won't halt
References: <494A0711.7010804@davidnewall.com> <20081219120530.GB1599@ucw.cz>
In-Reply-To: <20081219120530.GB1599@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-12-18 18:47:21, David Newall wrote:
>   
>> "poweroff -f -p" ... strangely came back after a few seconds.
>>     
>
> SMP? Care to try Mark Lord's recent patch on lkml?
A surprise to me; yes, the kernel is configured for SMP.    (The
hardware isn't.)  I can't find the patch.  Got another hint for me?

Thanks.
