Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXCNQnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXCNQnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXCNQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:43:14 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52750 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXCNQnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:43:13 -0400
Date: Wed, 14 Mar 2007 17:33:40 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <1173883577.31159.50.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0703141732540.1199@yvahk01.tjqt.qr>
References: <20070314050819.536207642@goodmis.org>  <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu>  <1173879210.31159.30.camel@localhost.localdomain>
  <20070314134112.GB13486@elte.hu> <1173883577.31159.50.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14 2007 10:46, Steven Rostedt wrote:
>
>> symbolic links perhaps? In that case i'd also introduce a common naming 
>> scheme: x86_early_printk.c - to make sure we know it right away that 
>> those files are bi-arch.
>
>Does the Linux code tree already support sym links? IOW, are there
>already sym links in the code tree? (/me probably should just look ;)

/usr/src/linux/include/asm -> /usr/src/linux/include/asm-i386


Jan
-- 
