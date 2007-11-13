Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXKMLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXKMLVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXKMLVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:21:20 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27464 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXKMLVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:21:19 -0500
Date: Tue, 13 Nov 2007 12:24:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113112435.GA16809@kernel.dk>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13 2007, Andrew Morton wrote:
> > I/O STORAGE===========================================================
> > 
> > kernel bug from pktcdvd
> > http://bugzilla.kernel.org/show_bug.cgi?id=9294
> > Kernel: 2.6.23
> 
> I think we might have fixed this.

It's fixed and merged, I just forgot to close the bugzilla. Did so now.

-- 
Jens Axboe

