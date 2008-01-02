Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYABDGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYABDGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYABDGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:06:09 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44722 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYABDGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:06:08 -0500
Message-ID: <477AFEA4.5060509@keyaccess.nl>
Date: Wed, 02 Jan 2008 04:01:56 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl>	<20071231122344.7b403cd8@the-village.bc.nu>	<4778FE42.6010003@keyaccess.nl> <20071231155600.0b06552c@the-village.bc.nu>
In-Reply-To: <20071231155600.0b06552c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-12-07 16:56, Alan Cox wrote:

>> Okay. Am about to go stuff my face with new years celebrations but will 
>> definitely try to make that old WD8003 hickup.
> 
> Have fun. Is it an 8390 or an 83905 ?

A DP8390BN. And I have a DP8390CN on a 3Com Etherlink II. The NE1000 has a 
DP83901AV, my new-fangled Networth combo WD/NE cards DP83905s.

Rene.
