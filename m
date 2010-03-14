Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0CNKjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0CNKjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:39:43 -0400
Date: Sun, 14 Mar 2010 03:39:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.34-rc1: Badness at fs/proc/generic.c:316
In-Reply-To: <20100314065526.GA5353@x200>
Message-ID: <alpine.DEB.2.01.1003140336280.5493@bogon.housecafe.de>
References: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de> <20100314065526.GA5353@x200>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/LT3SITot6eH+wbgGLyYUw8HYBeP8K73PByKL
 ZZ1NG7CytJVYBKOcqFWtHAdSwn3B5LHerhN6PBTBgwzfBuW4V3
 xWhEbNbdXptVDDVEv3Kqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Mar 2010 at 08:55, Alexey Dobriyan wrote:
> > device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
> > name 'pulses/rev'
> 
> Uh-oh.

Uh-oh? :-)

>> Is this something to worry about? The machine seems to run fine so far...
> 
> Runtime behaviour remains the same, it's just new warning message.

So...the laptop probably won't blow up before -rc2 is out? :-)

Christian.
-- 
BOFH excuse #298:

Not enough interrupts
