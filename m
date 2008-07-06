Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYGFItw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYGFItw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 04:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYGFItp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 04:49:45 -0400
Received: from mail.mba-software.de ([62.75.137.201]:35673 "EHLO
	mail.mba-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYGFIto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 04:49:44 -0400
Message-ID: <48708724.6020904@mba-software.de>
Date: Sun, 06 Jul 2008 10:49:40 +0200
From: =?ISO-8859-1?Q?Marian_Aldenh=F6vel?= 
	<marian.aldenhoevel@mba-software.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Gilles Espinasse <g.esp@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Building a kernel for SiS55-based system.
References: <4860959E.6020207@mba-software.de> <1214471767.48635e574384b@imp.free.fr>
In-Reply-To: <1214471767.48635e574384b@imp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What version of gcc,binutils?

Gcc: 4.2.3
Binutils: 2.18.50.0.3

> Could you try with distrib images to know if it could be related to your
> compilation system

As I have to boot off CF card, the system does not have a hard disk and does
not like to boot off my USB-CD-Drive, my choices in prebuilt-Distributions
are a bit limited.

I found Pyramid-Linux, using a 2.6.19 kernel. That one hangs at the
"Ok, now booting the kernel" prompt without further messages.

The standard Damn Small Linux kernel fails with "no math coprocessor or no
math emulation present", but that apparently is using a 2.4 kernel. DSL-n,
with a 2.6.x kernel hangs at the same time as pyramid-linux.

Any other suggestions?

Ciao, MM
-- 
Marian Aldenhövel, Rosenhain 23, 53123 Bonn
http://www.marian-aldenhoevel.de
"I ran some quick calculations on it. He's about 80% on the right
  track.  That leaves him only 20% dead when he crashes." Bob C




