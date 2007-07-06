Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbXGFSdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbXGFSdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762458AbXGFSdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:33:46 -0400
Received: from gw.goop.org ([64.81.55.164]:36175 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762417AbXGFSdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:33:46 -0400
Message-ID: <468E8B07.2030404@goop.org>
Date: Fri, 06 Jul 2007 11:33:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>	<468E6E33.3040000@zytor.com> <p737ipd1jsg.fsf@bingen.suse.de>
In-Reply-To: <p737ipd1jsg.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>   
>> For one thing, it looks like we're returning the wrong thing (EINVAL
>> rather than ENOTTY) across the board.  This was unfortunately a common
>> misunderstanding with non-tty-related ioctls in the early days of Linux.
>>     
>
> ENOTTY is so excessively misnamed that it is actually surprising
> anybody ever got that "right" (for very small values of right i guess)
>   

But it *isn't* a typewriter.  Of course, it's not a giraffe either.

    J
