Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYGPH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYGPH4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYGPH4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:56:06 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:55178 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYGPH4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:56:05 -0400
Message-ID: <487DA9E5.4020404@keyaccess.nl>
Date: Wed, 16 Jul 2008 09:57:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org> <20080715204320.GJ24533@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0807160951000.26724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807160951000.26724@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-07-08 09:53, Jan Engelhardt wrote:

> On Tuesday 2008-07-15 22:43, Adrian Bunk wrote:
>> The 2.6. prefix is like with X which is version 11 for 20 years and 
>> still counting.
>>
>> Or like with X11R6, that became X11R7 after 11 years, there might be
>> in a few years some big change that will warrant a 2.8 or 3.0 (the
>> rewrite of the kernel in Visual Basic .NET ;-) ).
> 
> Jumping the major number would really require some big flag day.
> What was it that made the jump from 1.x to 2.0?
> (Some ABI change w.r.t. binaries -- ELF becoming standard maybe?)

SMP support.

Rene
