Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYLFU6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYLFU6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYLFU6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:58:37 -0500
Received: from main.gmane.org ([80.91.229.2]:48586 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYLFU6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:58:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Date: Sat, 06 Dec 2008 14:58:24 -0600
Message-ID: <493AE770.5030507@shaw.ca>
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> Hi everyone,
> Mcelog just logged on my new Intel I7 920 (on Linux 2.6.27.8) this :
> MCE 0
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 0 BANK 6 MISC 202d ADDR ffeef740
> MCG status:
> MCi status:
> Error overflow
> Uncorrected error
> MCi_MISC register valid
> MCi_ADDR register valid
> Processor context corrupt
> MCA: Generic CACHE Level-2 Data-Write Error
> STATUS ee0000000100014a MCGSTATUS 0
> 
> I'm reporting this here, because I found in the Intel I7 Technical
> Specification November 2008 update that something which seems very
> similar is in fact an erratum. So my question is : Is there any way
> for me to verify that my problem is due to one of those errata,instead
> of a broken hardware(if we don't want to consider all those errata as
> broken hardware)? I'm also reporting this because I thought it may be
> useful to signal that(if actually due to those errata) these problems
> actually occur, so it may be useful to find workarounds in the kernel
> to not scare to death poor Linux users!

Which erratum are you talking about? I don't see one in that document 
that would match this case..

