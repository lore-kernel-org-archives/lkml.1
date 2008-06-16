Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYFPQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYFPQb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYFPQbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:31:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18580 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYFPQbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:31:45 -0400
Date: Mon, 16 Jun 2008 18:31:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Divyesh Shah <dpshah@google.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [BUGFIX][RESEND] Fix the starving writes bug in the anticipatory IO scheduler
Message-ID: <20080616163142.GL20851@kernel.dk>
References: <935894B7-5FD4-4C3D-9A74-6B18E532462B@google.com> <200806161318.57435.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806161318.57435.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2008, Nick Piggin wrote:
> Well, thanks for the report and test case. I'm a bit out of the
> loop when it comes to IO scheduling these days, however the fix
> seems good to me.
> 
> Does google still use AS scheduling? This doesn't introduce any
> performance regressions that you can tell?
> 
> Andrew might be away this week I think. Jens, any chance you can
> pick this up and get it merged when you feel it is ready?

It looks good to me, I'll queue it up.

-- 
Jens Axboe

