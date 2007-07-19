Return-Path: <linux-kernel-owner+w=401wt.eu-S940302AbXGSRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940302AbXGSRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939853AbXGSRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:07:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:61379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939749AbXGSRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:07:03 -0400
Date: Thu, 19 Jul 2007 19:05:13 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Bodo Eggert <7eggert@gmx.de>, Ray Lee <ray-lk@madrabbit.org>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <469D5755.3050301@gmail.com>
Message-ID: <Pine.LNX.4.58.0707191857140.3442@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> 
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> 
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> 
 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
 <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
 <469C0D32.2090102@gmail.com> <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
 <469CD456.801@gmail.com> <Pine.LNX.4.58.0707172334210.2141@be1.lrz>
 <469D5755.3050301@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19wfzz3AdIJJctGF9OOng9WgihIampShX6T4H9
 Upzhf0xCr9iWX7jN5Iusukmkasvt9C/WyLuN0dYKGhpEuT0LMB
 qh6LXEdAxoab2x3S5waLw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Rene Herman wrote:
> On 07/18/2007 01:19 AM, Bodo Eggert wrote:

> > Please post a list of things you have designed, so I can avoid them.
> 
> - The ability to read
> - The ability to understand
> 
> You're doing a hell of a job already.

If you designed them like you design secure systems, that explains a lot.

-- 
Top 100 things you don't want the sysadmin to say:
83. Damn, and I just bought that pop...
