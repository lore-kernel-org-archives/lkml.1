Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbYBGUmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbYBGUmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYBGUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:42:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862AbYBGUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:42:13 -0500
Date: Thu, 7 Feb 2008 12:42:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: stephen.neuendorffer@xilinx.com, grant.likely@secretlab.ca,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Kumar Gala <galak@gate.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
Message-Id: <20080207124203.147ce300.akpm@linux-foundation.org>
In-Reply-To: <47AB6552.7040503@gmail.com>
References: <47AB6552.7040503@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 21:08:50 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> first of all, I think that the driver should go through lkml before upstream 
> merge or at least be in -mm for a while (I think this used to be a rule some 
> time ago), correct me if I'm wrong, but none of it happened.

Never seen it before in my life.  Can't find any references to it in any of
the mailing lists.  I ended up googling the changelog text for a whopping
three hits and it appears that this change went into the powerpc patch
system (http://patchwork.ozlabs.org/linuxppc/patch?id=16712)

How it got from there into Linux is also a mystery.  I see a batch of
powerpc updates just went into mainline but I don't know whose tree was
pulled - I wasn't copied on any pull request and I can't find one on the
kernel mailing list.

Perhaps Paul has just done a stealth merge, but the patch to which you
refer doesn't have his signoff.  Very confused.

Guys, can we all play too?
