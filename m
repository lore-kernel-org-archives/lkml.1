Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXEWHPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXEWHPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEWHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:14:54 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:54581 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXEWHOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:14:53 -0400
Content-Disposition: inline
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v13
Date: Wed, 23 May 2007 09:14:49 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200705230914.50013.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to mail earlier, but I had always something get in my way.

I used cfs v13 since you announced it. Since patching the kernel (2.6.21.1) 
with cfs v13 
I did the following things;

- big backup of home onto tape and restoring it after changing to reiser4 
(yes, I know the threads about its problems, but I always wanted to try it - 
and when fragmentation reached the point of unbearable, I switched. The 
really important stuff is still on a different fs, and I figured that using 
an experimental fs might be the kick I need to do frequently updates 
again..).

- lots and lots and lots of compiling. And then some more compiling.

- burning dvds (I also switched to libata - if you go experimental, why don't 
do it completly... only the dvd drive and a 'data dump' harddisk are 
affected.. but hey, since then no surprise-pio-mode anymore...)

- some ut2004 

- assorted desktop stuff. typing, surfing, video, music,  - most of 
it in parallel. some 'minor' games like freeciv, wesnoth, lgeneral.

- some vegastrike-svn

So far I am pretty satisfied.  I can't see any regressions, music is 
skip-free, videos play nice, burning dvds is fast, ut2004 and vegastrike play 
well. The other games can't be better and did not get worse. Everything else 
behaves like always.

Glück Auf,
Volker
