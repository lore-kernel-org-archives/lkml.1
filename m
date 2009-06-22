Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZFVVu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZFVVu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFVVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:50:17 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:49995 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240AbZFVVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:50:16 -0400
X-SpamScore: -31
X-BigFish: VPS-31(zz1432R98dR1805M179dNzz1202hzzz2fh6bh17ch62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4A3FFC89.4070006@am.sony.com>
Date: Mon, 22 Jun 2009 14:50:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marco <marco.stornelli@gmail.com>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FC84A.6060608@gmail.com> <20090622204031.GA24236@elf.ucw.cz>
In-Reply-To: <20090622204031.GA24236@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 21:50:02.0757 (UTC) FILETIME=[65992350:01C9F383]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> block of fast non-volatile RAM that need to access data on it using a
>> standard filesytem interface."
> 
> Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
> better with ext2.

Not if you want the RAM-based filesystem to persist over a kernel
invocation.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

