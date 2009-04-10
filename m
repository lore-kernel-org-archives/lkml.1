Return-Path: <linux-kernel-owner+w=401wt.eu-S936651AbZDJQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936651AbZDJQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbZDJQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:52:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26917 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbZDJQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YaJI5yvz15A4yTVJL5o52hxRZhG0JKx2PjQgouYsn5lPXhocqgrjIFzbtyuPjy0ufv
         1Y+H19OuFhVMddBGJAg3K58cbtMJTo4KoM/8YUPARBB9zizzA6j9EE6WbueeltzSDyrD
         aaekQlejPHAaiu6moEGcqAOUYgFvQ0QL3bhAg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
	 <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
	 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
	 <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
Date: Fri, 10 Apr 2009 18:52:55 +0200
Message-ID: <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgot CC)

2009/4/10 Thomas Gleixner <tglx@linutronix.de>:

>
> Is this with my patch applied ?

Yes. I didn't observe any change.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
