Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870Ab0AVKr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0AVKr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705Ab0AVKr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:47:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0AVKrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:47:55 -0500
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/24] drivers/block/floppy.c cleanups
From: Andi Kleen <andi@firstfloor.org>
References: <cover.1264133863.git.joe@perches.com>
Date: Fri, 22 Jan 2010 11:47:53 +0100
In-Reply-To: <cover.1264133863.git.joe@perches.com> (Joe Perches's message of "Thu, 21 Jan 2010 20:52:30 -0800")
Message-ID: <87fx5yh0va.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Since Stephen Hemminger is a bit too busy to do much with this
> I've broken up the first large patch into multiple pieces and
> brought the rest up to current.

Philosophically I'm not sure it's that great an idea to make bad code
look better without actually fixing/rewriting it. It's like putting
lipstick on a pig.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
