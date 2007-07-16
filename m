Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbXGPVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbXGPVOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbXGPVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:14:25 -0400
Received: from lazybastard.de ([212.112.238.170]:46030 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbXGPVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:23 -0400
Date: Mon, 16 Jul 2007 23:10:49 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Al Boldi <a1426z@gawab.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
Message-ID: <20070716211049.GA3537@lazybastard.org>
References: <200707161722.53203.a1426z@gawab.com> <a781481a0707160944h2f991739p69058208cdf13f76@mail.gmail.com> <20070716165312.GA32647@lazybastard.org> <200707162023.04646.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707162023.04646.a1426z@gawab.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 July 2007 20:23:04 +0300, Al Boldi wrote:
> Jörn Engel wrote:
> 
> > The only place that can ensure to always break the
> > link is the kernel.  Which is why I wrote the cowlink patches some years
> > back.
> 
> Can you post a patch against 2.6.22?

I can and probably will.

> > The still need a lot of love to be merge-ready.  But I do use them on a
> > daily basis.
> 
> Well, if the patch is lean and optional and runtime configurable, then they 
> should definitely be considered for inclusion.

Lean is not the word I would choose.  It works.  For me.  That is about
as much praise as it deserves.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
