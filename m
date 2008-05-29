Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYE2CPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYE2CPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYE2CPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:15:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYE2CPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:15:40 -0400
Message-ID: <483E111E.9050804@cn.fujitsu.com>
Date: Thu, 29 May 2008 10:12:46 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Call for nominations
References: <E1K1TIQ-0000l8-9d@closure.thunk.org>
In-Reply-To: <E1K1TIQ-0000l8-9d@closure.thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o said the following on 2008-5-29 5:34:
> This year, we're starting a bit late (mea culpa), so I'd like to start
> this process going sooner rather than later.  I've assembled a list of
> people who have contributed significantly to the kernel in recent months
> (since September 2007), as measured by Signed-off-by's and Acked-by's.

Ted, No suspicion about the list, just curious.

By SOF and AB we can collect people who contributed most changesets to kernel.
But, how about those who contributed most lines and not so many changesets?

For example:
---- Contributed most changesets TOP30 in 2.6.25
No.1	 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
No.2	 Adrian Bunk <adrian.bunk@movial.fi>
No.3	 Patrick McHardy <kaber@trash.net>
No.4	 Ingo Molnar <mingo@elte.hu>
No.5	 Paul Mundt <lethal@linux-sh.org>
No.6	 Greg Kroah-Hartman <gregkh@suse.de>
No.7	 Jesper Nilsson <jesper.nilsson@axis.com>
No.7	 Thomas Gleixner <tglx@linutronix.de>
No.9	 Pavel Emelyanov <xemul@openvz.org>
No.10	 Harvey Harrison <harvey.harrison@gmail.com>
No.11	 Herbert Xu <herbert@gondor.apana.org.au>
No.12	 Mauro Carvalho Chehab <mchehab@infradead.org>
No.12	 Roland McGrath <roland@redhat.com>
No.14	 David Woodhouse <dwmw2@infradead.org>
No.15	 Al Viro <viro@ftp.linux.org.uk>
No.16	 Michael Krufky <mkrufky@linuxtv.org>
No.17	 Glauber Costa <gcosta@redhat.com>
No.18	 David S. Miller <davem@davemloft.net>
No.19	 Andrew Morton <akpm@linux-foundation.org>
No.20	 Takashi Iwai <tiwai@suse.de>	
No.21	 Joe Perches <joe@perches.com>
No.22	 Avi Kivity <avi@qumranet.com>	
No.23	 Jean Delvare <khali@linux-fr.org>	
No.24	 Sam Ravnborg <sam@ravnborg.org>	
No.25	 Randy Dunlap <rdunlap@xenotime.net>	
No.26	 Denis V. Lunev <den@openvz.org>	
No.27	 Andi Kleen <ak@suse.de>	
No.27	 Jan Engelhardt <jengelh@gmx.de>	
No.29	 Tejun Heo <htejun@gmail.com>	
No.29	 Chuck Lever <chuck.lever@oracle.com>	

---- Contributed most lines TOP30 in 2.6.25
No.1	 Paul Mundt <lethal@linux-sh.org>	
No.2	 Jesper Nilsson <jesper.nilsson@axis.com>	
No.3	 Avi Kivity <avi@qumranet.com>	
No.4	 Kumar Gala <galak@kernel.crashing.org>	 
No.5	 Adrian Bunk <adrian.bunk@movial.fi>	
No.6	 David Howells <dhowells@redhat.com>	 
No.7	 Eliezer Tamir <eliezert@broadcom.com>	 
No.8	 Christoph Hellwig <hch@lst.de>	
No.9	 Jiri Slaby <jirislaby@gmail.com>	
No.10	 Ingo Molnar <mingo@elte.hu>	
No.11	 Michael Chan <mchan@broadcom.com>	
No.12	 Thomas Gleixner <tglx@linutronix.de>	
No.13	 Glenn Streiff <gstreiff@neteffect.com>	 
No.14	 Jens Axboe <jens.axboe@oracle.com>	 
No.15	 Roland McGrath <roland@redhat.com>	 
No.16	 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>	 
No.17	 Mauro Carvalho Chehab <mchehab@infradead.org>	 
No.18	 Patrick McHardy <kaber@trash.net>	
No.19	 Auke Kok <auke-jan.h.kok@intel.com>	
No.20	 James Bottomley <James.Bottomley@HansenPartnership.com>	
No.21	 David Gibson <dwg@au1.ibm.com>	 
No.22	 Michael Krufky <mkrufky@linuxtv.org>	
No.23	 Takashi Iwai <tiwai@suse.de>	
No.24	 Greg Kroah-Hartman <gregkh@suse.de>	
No.25	 Benjamin Herrenschmidt <benh@kernel.crashing.org>	
No.26	 Geert Uytterhoeven <geert@linux-m68k.org>	
No.27	 Herbert Xu <herbert@gondor.apana.org.au>	
No.28	 Harvey Harrison <harvey.harrison@gmail.com>	
No.29	 Glauber Costa <gcosta@redhat.com>	
No.30	 David Woodhouse <dwmw2@infradead.org>	

Obviously, some people contributed a lot of lines to kernel, but their
patch number is not so remarkable.

