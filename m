Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYJBQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYJBQJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYJBQJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:09:35 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50651 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbYJBQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:09:34 -0400
Date: Thu, 2 Oct 2008 12:09:33 -0400
To: Matthew Stoltenberg <d3matt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: motherboard recommendations?
Message-ID: <20081002160933.GM22849@csclub.uwaterloo.ca>
References: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com> <20081002143809.GA22851@csclub.uwaterloo.ca> <3c1bc2140810020803l33207ecbsbd690fa33a21a360@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1bc2140810020803l33207ecbsbd690fa33a21a360@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 10:03:55AM -0500, Matthew Stoltenberg wrote:
> I got an ASUS P5Q (P45 chipset) a couple of weeks ago.  A couple of
> minor issues:
> * The Marvell IDE controller is broken in 2.6.25 and 2.6.26.

Well I must admit I have never tried a marvell ide controller before.
Support only seems very recent, so they are not yet on my list of things
I know work.

> * Make sure the sata controller is running in AHCI mode

Well of course, AHCI is a lovely feature to have.

> * The onboard Atheros NIC is not supported in the kernel.  I have to
> build the driver seperately (it's actually on the driver disk)

Atheros?  Hmm, the P5K was using atlantic, so I wonder why they are not
using atheros.

> The intel HD audio works great.

That's always something.

So overall it sounds like:

Sound works
IDE probably will soon
Networking can be made to work, and hopefully will go in mainline kernel
soon.
SATA works.

That's not too bad for a brand new board.

-- 
Len Sorensen
