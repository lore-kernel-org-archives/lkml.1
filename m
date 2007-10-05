Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbXJETcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbXJETcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbXJETcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:32:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38057 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbXJETcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:32:12 -0400
Date: Fri, 5 Oct 2007 21:32:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <20071005192404.GB4003@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0710052126271.13406@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <20071005191940.GA4003@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0710052120270.13406@fbirervta.pbzchgretzou.qr>
 <20071005192404.GB4003@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 15:24, Lennart Sorensen wrote:
>On Fri, Oct 05, 2007 at 09:21:57PM +0200, Jan Engelhardt wrote:
>> Indeed it should be 0x07, should it go in.
>> Otherwise the openbsd camp might start another flamewar.
>> 
>> (On a personal note, would 0x1F work better for you?)
>
>No, I actually find most things hard to read on a blue background.
>Besides black uses less power on a CRT (and probably OLED as well)
>monitor.  LCDs probably don't care.  :)
>
Ah you seem to be a proponent of http://www.blackgoogle.com/
then :-)  Unfortunately, it seems like Xft uses Grayscale AA
(http://antigrain.com/research/font_rasterization/index.html)
so black background make the font look thinner.
