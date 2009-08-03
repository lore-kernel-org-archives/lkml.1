Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZHCSif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZHCSif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZHCSie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:38:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57248 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753488AbZHCSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:38:34 -0400
Date: Mon, 3 Aug 2009 19:39:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] tty-ldisc: turn ldisc user count into a proper
 refcount
Message-ID: <20090803193924.1fb0e733@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0908031058330.3208@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
	<20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
	<alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
	<alpine.LFD.2.01.0908031055400.3208@localhost.localdomain>
	<alpine.LFD.2.01.0908031058330.3208@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me on first review.

Acked-by: Alan Cox <alan@linux.intel.com>
