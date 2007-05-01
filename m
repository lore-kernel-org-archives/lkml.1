Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXEABnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXEABnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933382AbXEABnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:43:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbXEABnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:43:04 -0400
Message-ID: <46369B03.1060500@zytor.com>
Date: Mon, 30 Apr 2007 18:42:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <46369A8F.1050809@garzik.org>
In-Reply-To: <46369A8F.1050809@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Do you mean the SVGA chip-specific code, or additionally you are ripping
> out CGA and EGA support?
> 

I mean the SVGA chip-specific code.

> Out of curiosity what C compiler will you use?

gcc, using the ".code16gcc" feature of any non-prehistoric binutils.

	-hpa
