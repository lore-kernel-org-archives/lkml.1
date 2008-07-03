Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYGCHAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYGCHAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYGCG5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbYGCBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:40:19 -0400
Date: Wed, 2 Jul 2008 18:39:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
In-Reply-To: <20080702164128.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.1.10.0807021839390.18105@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0807011300110.21227@anakin> <20080701084316.ZZRA012@mailhub.coreip.homeip.net> <20080701130517.GA29863@cs181140183.pp.htv.fi> <20080701092542.ZZRA012@mailhub.coreip.homeip.net> <20080702164128.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jul 2008, Dmitry Torokhov wrote:
> 
> Linus, will you apply Geert's patch directly or you would prefer me
> set up my tree for another pull?

I took it directly.

		Linus
