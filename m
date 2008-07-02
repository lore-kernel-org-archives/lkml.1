Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYGBUno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYGBUno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYGBUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:43:35 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:4399 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYGBUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uVG33GR7CNWI3a2QtwaOy9YEXulBSmg0aLHaX0n6v5PhVMvpxrPe1o1hvJ2/YVeTxn
         xZUoNgzq/bknp+zHXmr/S242qRwcDG1UOt6eUR/MvVKco15xpXLvcExsiXA3U+r+A8lv
         UAQQagtayGfA2UgoIGym/1G8f0dzyy3VV5HEk=
Date: Wed, 2 Jul 2008 16:43:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
Message-ID: <20080702164128.ZZRA012@mailhub.coreip.homeip.net>
References: <Pine.LNX.4.64.0807011300110.21227@anakin> <20080701084316.ZZRA012@mailhub.coreip.homeip.net> <20080701130517.GA29863@cs181140183.pp.htv.fi> <20080701092542.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701092542.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 09:27:02AM -0400, Dmitry Torokhov wrote:
> On Tue, Jul 01, 2008 at 04:05:17PM +0300, Adrian Bunk wrote:
> > 
> > Can we go with Geert's patch for 2.6.26 and if you want to fix it 
> > properly you can send a patch for 2.6.27?
> > 
> 
> No, no, I am totally fine with Geert's fix, I am talking about later of
> course.

Linus, will you apply Geert's patch directly or you would prefer me
set up my tree for another pull?

-- 
Dmitry
