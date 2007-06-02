Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXFBHt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXFBHt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXFBHtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:49:22 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:49312 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbXFBHtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:49:21 -0400
Date: Sat, 2 Jun 2007 09:51:18 +0200
From: DervishD <lkml@dervishd.net>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602075118.GA20406@DervishD>
Mail-Followup-To: Ken Moffat <zarniwhoop@ntlworld.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <20070601221700.GA15242@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070601221700.GA15242@deepthought>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Ken :)

 * Ken Moffat <zarniwhoop@ntlworld.com> dixit:
> On Fri, Jun 01, 2007 at 04:20:58PM +0200, DervishD wrote:
> >     Will the console work as it works now if I can live with latin1
> > accented characters only? Is there any terminal emulator *for the
> > console*, not for X, that handles utf8? Will I be sentenced to X to be
> > able to use my computer with utf8?
> > 
>  Sure, the console will work (don't know about a console terminal
> emulator).  I'm not very keen on compose keys - I find dead
> diacriticals (like in X) are usually easier to enter, and I've got
> all the dead latin1 accents working on my uk keymap.

    I only use compose keys for a bunch of characters like © (copyright
mark) for example. For any other I use dead diacriticals (for example,
to write the accented chars for my mother tongue).

> You can also alter the keymap to allow you do ISO 14755 input
> (ctrl+shift+hex_digits) - useful for occasional characters, if they
> are in your font and you can remember their value.

    I have my keymap modified for that, and I use it as a last resort.
If I find myself using AltGr+hex (that's the key combo I use), I usually
put that character in a compose.

    Thanks for the info, I'm very happy to hear that it works :)))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
