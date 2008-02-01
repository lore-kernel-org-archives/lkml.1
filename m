Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbYBAKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbYBAKr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbYBAKrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:47:37 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4276 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbYBAKrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:47:36 -0500
Date: Fri, 1 Feb 2008 11:47:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080201104733.GM15220@kernel.dk>
References: <20080131221436.GA3760@elte.hu> <20080201084056.GH15220@kernel.dk> <20080201104537.GA27178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201104537.GA27178@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Are you sure this triggered with the as fixup in place? It looks like 
> > the same bug.
> 
> most definitely a separate bug.

yeah, I didn't read it carefully enough. Nikanth found the reason.

-- 
Jens Axboe

