Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbXGKJrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbXGKJrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbXGKJr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:47:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:54289 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640AbXGKJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:47:27 -0400
Message-ID: <4694A736.5000608@qumranet.com>
Date: Wed, 11 Jul 2007 12:47:34 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Benjamin Budts <benjamin.budts@scarlet.be>
CC: kvm-devel@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] gcc + kvm + 64 bit ? confused :-/
References: <11838956891287-git-send-email-avi@qumranet.com>		<p73lkdqzpdm.fsf@bingen.suse.de>	<4691D9C1.4050309@qumranet.com>		<20070709071640.GB10864@one.firstfloor.org>		<46920270.3080309@qumranet.com>	<46921BE9.4040801@qumranet.com>		<a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>		<4693211D.4040406@qumranet.com>		<a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com>		<46936766.20900@qumranet.com>	<a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com>	<46948626.6050308@qumranet.com> <4694A63E.1050606@scarlet.be>
In-Reply-To: <4694A63E.1050606@scarlet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Budts wrote:
> Hi all,
>
> question...
>
> I'm a bit confused using the -march=xxx options for gcc when using a 
> kernel virtual machine...
> Getting errors on smp when using the -march=nocoma for gcc... possibly 
> because smp is not fully supported yet I suppse.
>
> I guess my question is, when installing kvm, is the virtual machine 64 
> bit capable or should I install 32 bit OS ?
>   

kvm supports 64-bit and 32-bit guests if running on a 64-bit host.

> I installed an amd64 debian image and it seems to be running 
> fine...except for the problem mentioned above.
>
> And what type of architecture do i have to mention with gcc in a kvm ? 
> march ... arch...
>   

Please post the errors.

-- 
error compiling committee.c: too many arguments to function

