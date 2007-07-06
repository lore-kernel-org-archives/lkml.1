Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbXGFSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbXGFSh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbXGFShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:37:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbXGFShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:37:20 -0400
Message-ID: <468E8BBF.9020907@zytor.com>
Date: Fri, 06 Jul 2007 11:36:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>	<468E6E33.3040000@zytor.com> <p737ipd1jsg.fsf@bingen.suse.de> <468E8B07.2030404@goop.org>
In-Reply-To: <468E8B07.2030404@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> ENOTTY is so excessively misnamed that it is actually surprising
>> anybody ever got that "right" (for very small values of right i guess)
> 
> But it *isn't* a typewriter.  Of course, it's not a giraffe either.
> 

The union of things that are not typewriters and not giraffes are rather
large, indeed.

This is getting philosophical.

	-hpa
