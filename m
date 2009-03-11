Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZCKK6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZCKK6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZCKK6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:58:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:41002 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbZCKK6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:58:37 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be>
References: <1236729444.7086.24.camel@pasglop>
	 <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Mar 2009 21:57:05 +1100
Message-Id: <1236769025.7086.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 10:37 +0100, Geert Uytterhoeven wrote:
> On Wed, 11 Mar 2009, Benjamin Herrenschmidt wrote:
> > Here are some late fixes for 2.6.29. I've included a radeonfb/aty128fb commit
> 
> Will you also take care of the new ps3vram driver, which has been ack'ed by
> Jens for 2.6.29?
> Or do you prefer it to go in by email through Geoff (as PS3 maintainer), or
> from me directly?

I'd like to have Andrew or Linus opinion on doing this driver swap that
late in the process.

Ben.

> Thanks!
> 
> With kind regards,
> 
> Geert Uytterhoeven
> Software Architect
> 
> Sony Techsoft Centre Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
> 
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
> 
> A division of Sony Europe (Belgium) N.V.
> VAT BE 0413.825.160 · RPR Brussels
> Fortis · BIC GEBABEBB · IBAN BE41293037680010

