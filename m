Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZHCSyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZHCSyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZHCSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:54:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbZHCSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:54:02 -0400
Date: Mon, 3 Aug 2009 11:53:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
In-Reply-To: <20090803181811.GA15848@kroah.com>
Message-ID: <alpine.LFD.2.01.0908031152130.3208@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, Greg KH wrote:
> 
> Ok, I'll queue them up if they pass Sergey's testing.

Btw, looking at my email, I think the commentary explanations I wrote for 
you guys (under the "---") might as well be lifted up into the actual 
commit comments. They're valid long-term commentary on some of the issues 
that remain.

		Linus
