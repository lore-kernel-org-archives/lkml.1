Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbXBSOgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbXBSOgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbXBSOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:36:23 -0500
Received: from brick.kernel.dk ([62.242.22.158]:2122 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbXBSOgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:36:22 -0500
Date: Mon, 19 Feb 2007 15:36:12 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-mm2 -- EIP is at __make_request+0xeb/0x2ee
Message-ID: <20070219143612.GM17728@kernel.dk>
References: <a44ae5cd0702181347l4551aaefxf083e5260ea274ce@mail.gmail.com> <20070218143517.238d7a0e.akpm@linux-foundation.org> <20070218144743.3eff0299.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218144743.3eff0299.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18 2007, Andrew Morton wrote:
> On Sun, 18 Feb 2007 14:35:17 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I guess I need to do a git-blockless -mm3
> 
> OK, this is looking like a pain - I'd have to drop or significantly redo
> thirty or more patches.  Jens, please fix it asap.

Will get on it, I wonder what on earth broke this time :(
This plugging stuff will really have to show some merrit in the
performance arena, otherwise it'll go out again soon.

-- 
Jens Axboe

