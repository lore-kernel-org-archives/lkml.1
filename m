Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYEFIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYEFIcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYEFIcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:32:05 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:64095 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753653AbYEFIcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:32:01 -0400
Message-ID: <482017C3.2070508@seznam.cz>
Date: Tue, 06 May 2008 10:33:07 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arnd Bergmann <arnd@arndb.de>, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <4813DF3E.6080800@itee.uq.edu.au> <4814A153.3040600@seznam.cz> <200805032357.41043.arnd@arndb.de> <481D7DF7.3000909@seznam.cz> <481E3433.2030408@zytor.com>
In-Reply-To: <481E3433.2030408@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,
>>
>> /* kernel/sys_ni.c */
>>     .long sys_ni_syscall /*  :-)  */
>>
> 
> There is a school of thought that it's useful to reserve a system call
> number (usually zero) as a system call that is *guaranteed* to have no
> effect.

I like your opinion. I'll add it like zero syscall.

Thanks,
M


