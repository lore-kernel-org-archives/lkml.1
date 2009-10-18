Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZJRWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZJRWjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZJRWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:39:40 -0400
Received: from xenotime.net ([72.52.64.118]:55160 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753952AbZJRWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:39:39 -0400
Date: Sun, 18 Oct 2009 15:39:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Peter Stuge <peter@stuge.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Adding an ioctl or three
Message-Id: <20091018153942.aeef78ee.rdunlap@xenotime.net>
In-Reply-To: <20091018223306.17571.qmail@stuge.se>
References: <20091015205803.30544.qmail@stuge.se>
	<20091015223137.6b9fb55a@lxorguk.ukuu.org.uk>
	<20091015214642.6208.qmail@stuge.se>
	<20091015230853.44fb10c1@lxorguk.ukuu.org.uk>
	<20091018162737.18611.qmail@stuge.se>
	<20091018223306.17571.qmail@stuge.se>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 00:33:06 +0200 Peter Stuge wrote:

> Peter Stuge wrote:
> > Is patching Documentation/ioctl/ioctl-number.txt and
> > asm/ioctls.h all?
> 
> I added an ioctl into a header of my own. It works fine, but..
> 
> 
> > The "addressing" in ioctl-number seems a little chaotic, do I just
> > pick anything that is available?
> 
> Documentation/ioctl/ioctl-number.txt seems out of date. I picked
> a number that was used (by linux/toshiba.h) but not listed. Do I have
> to grep it out?

Can you at least list what files/drivers need to be added to
Documentation/ioctl/ioctl-number.txt, please?

---
~Randy
