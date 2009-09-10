Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZIJMT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZIJMT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZIJMT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:19:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45281 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZIJMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:19:56 -0400
Date: Thu, 10 Sep 2009 14:19:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: latt location (Was Re: BFS vs. mainline scheduler benchmarks and
	measurements)
Message-ID: <20090910121959.GT18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090909073851.GD1327@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909073851.GD1327@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Pavel Machek wrote:
> Could you post the source? Someone else might get us
> numbers... preferably on dualcore box or something...

Since it's posted in various places and by various people, I've put it
on the web now as well. Should always be the latest version.

http://kernel.dk/latt.c

Note that it requires zlib-devel packages to build now.

-- 
Jens Axboe

