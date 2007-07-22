Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbXGVX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbXGVX76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXGVX7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:59:46 -0400
Received: from osiris.atheme.org ([69.60.119.211]:49900 "EHLO
	osiris.atheme.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756192AbXGVX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:59:45 -0400
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 19:59:45 EDT
Message-ID: <46A3E7BA.6030609@partiallystapled.com>
Date: Sun, 22 Jul 2007 19:26:50 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com> <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr> <20070722211314.GA13850@linux-sh.org> <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr> <46A3D5EA.2050600@zytor.com>
In-Reply-To: <46A3D5EA.2050600@zytor.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=94C1C841
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Wouldn't be hard to make a git tree with all the patches all the way
> back to 0.01 even...

It'd be delightful from a completeness standpoint (and I do love
completeness), but considering it already takes a good 20 minutes to
clone the 2.6 tree over a respectable cable connection, I'd have to
object on the grounds of size. Now, if it was kept off in its own tree
for people who don't mind ravaging kernel.org resources to satisfy their
own curiosity, that's fine too.

  -- m. tharp
