Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbXFANBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbXFANBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXFANA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:00:57 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:54191 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbXFANA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:00:57 -0400
To: michal.k.k.piotrowski@gmail.com
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-reply-to: <46600F1C.5000302@googlemail.com> (message from Michal Piotrowski
	on Fri, 01 Jun 2007 14:20:44 +0200)
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
References: <46600F1C.5000302@googlemail.com>
Message-Id: <E1Hu6k5-0001Xm-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Jun 2007 15:00:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : long freezes on thinkpad t60
> References : http://lkml.org/lkml/2007/5/24/100
> Submitter  : Miklos Szeredi <miklos@szeredi.hu>
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Status     : problem is being debugged

This isn't a regression strictly speaking, as 2.6.21 is known to be
affected, and older kernels might also be.

It's non-fatal and only happens under very special circumstances, so
it's definitely not a showstopper.

I don't mind being bugged about this once in a while, this is just for
clarification.

Miklos
