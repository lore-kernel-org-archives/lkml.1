Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXG1Rdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXG1Rdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXG1Rdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:33:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51325 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXG1Rdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:33:39 -0400
Date: Sat, 28 Jul 2007 19:33:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
  <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
 <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
 <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 10:12, Linus Torvalds wrote:
>
>The fact is, I've _always_ considered the desktop to be the most important 
>part. [...]
>The fact is, most kernel developers realize that Linux is used in 
>different places, on different machines, and with different loads. You 
>cannot make _everybody_ happy, but you can try to do as good a job as 
>possible. And doing "as good a job as possible" very much includes not 
>focusing on any particular load.

You cannot please everybody in the scheduler question, that is clear,
then why not offer dedicated scheduling alternatives (plugsched comes to mind)
and let them choose what pleases them most, and handles their workload best?



	Jan
-- 
