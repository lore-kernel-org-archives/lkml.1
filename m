Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZBJKK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZBJKK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZBJKKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:10:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60718 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBJKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:10:20 -0500
Date: Tue, 10 Feb 2009 11:10:19 +0100
From: Pavel Machek <pavel@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Message-ID: <20090210101019.GB27018@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com> <498D9F02.9000107@tremplin-utc.net> <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com> <20090209094748.GC4358@atrey.karlin.mff.cuni.cz> <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com> <20090209095803.GD4358@atrey.karlin.mff.cuni.cz> <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com> <cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 9, 2009 at 12:45 PM, Giuseppe Bilotta
> <giuseppe.bilotta@gmail.com> wrote:
> > I will try this patch
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00164.html in
> > the mean time, in case that's the patch which is in -mm.
> 
> With that patch I still get the same range of fluctuations.

Yeah, that patch. Not sure what to do next... you could grab lis3
manual and see if you can setup chip by hand to get better results...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
