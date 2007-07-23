Return-Path: <linux-kernel-owner+w=401wt.eu-S934581AbXGWTpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbXGWTpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764467AbXGWTpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:45:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765379AbXGWTpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:45:21 -0400
Date: Mon, 23 Jul 2007 12:44:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
In-Reply-To: <20070723185732.GB30165@thunk.org>
Message-ID: <alpine.LFD.0.999.0707231242090.3607@woody.linux-foundation.org>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org> <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com> <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
 <20070723185732.GB30165@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Theodore Tso wrote:
> 
> Um, *I* never had the bad taste to import Linux kernels into CVS.  :-)

Ahh. I just checked. 

RCS.

There are old linux archive of yours that has some RCS files in it (0.10 
and 0.12 at least)

		Linus
