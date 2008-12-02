Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYLBP4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYLBP4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLBP4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:56:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:18925 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLBP4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:56:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ko3uNNyp+5C+a+h8/pKm/wpu6k/tI+6Yy0KxAeNuZXOvCo9xvLZ6Z2tiqKLYz5SYIw
         w0U03yTMKuGEgxoKYQ6jM3NDsaKHnAXSKT6fc+6/ORlKVzwN84c6+QRvK067sV2eeJi+
         IZVB9nuXGNW7h0mHUYJvkDieJWBrrGTu9+TzE=
Date: Tue, 2 Dec 2008 16:56:37 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202165637.09984819@varda>
In-Reply-To: <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131442.42e7df48@varda>
	<alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 07:50:05 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> 
> On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> >  
> >  All of this happens without the nvidia module loaded (not even compiled) 
> 
> It's definitely loaded according to your dmesg:
> 
> > [    0.000000] Linux version 2.6.28-rc7 (alex@varda) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #2 SMP PREEMPT Tue Dec 2 12:48:19 CET 2008
> ...
> > [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> > [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
> > [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> > [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06  Sat Nov  8 17:50:38 PST 2008
> 
> Hmm?? Can you double-check?

 from my reply to pazke <pazke@ports.donpac.ru>
 "
I took the sanpshot of the dmesg after loading the module if my word is not
enough i can reboot with the module disabled but i do not see the point...
The truth is that the bug prevented me from loading/installing the nvidia
module becouse i could not use sudo. Only when i rebooted into single mode
where the problems went away i could build and install the module...
"

> 
> 		Linus

 Thanks for you time

