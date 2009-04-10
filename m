Return-Path: <linux-kernel-owner+w=401wt.eu-S939326AbZDJR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939326AbZDJR5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZDJR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:57:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60575 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761284AbZDJR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TeWRJ6s+x5yq7COkThYCl+uzhP7+9wdfrZxY5G1IJoPuACb7WHyv4zsPcvVJXMSWhT
         bmcuUD0sHx7kdOcqwBYoUcKC8YDWJIyKsthlBjVVjRfvFRFcHSysE2Mvds3Zu/2UNsic
         ipSZlbR5G9N5mndebHxcds3XZ4C1LikpWx0Qk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904101854250.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
	 <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
	 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
	 <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
	 <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
	 <alpine.LFD.2.00.0904101854250.21577@localhost.localdomain>
Date: Fri, 10 Apr 2009 19:57:15 +0200
Message-ID: <8db1092f0904101057x56000b73w9de3227b2a3a9abb@mail.gmail.com>
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

2009/4/10 Thomas Gleixner <tglx@linutronix.de>:

[...]
> Please upload trace.bz2 file to some place.

http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/trace-2.6.30-rc1-git3.bz2

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
