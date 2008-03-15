Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYCOMkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYCOMkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 08:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYCOMju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 08:39:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2880 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751706AbYCOMjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 08:39:49 -0400
Date: Sat, 15 Mar 2008 13:39:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/4] disk-protect: Add disk shock protection helpers to libata
Message-ID: <20080315123933.GA4669@ucw.cz>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core> <87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core> <87bq5qfm2v.fsf@denkblock.local> <20080307181750.9981.88028.stgit@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307181750.9981.88028.stgit@denkblock.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-07 19:25:16, Elias Oltmanns wrote:
> This patch adds some helper functions to libata in order to provide low
> level suport for disk shock protection. The user interface to this
> functionality will be implemented in the block layer in a subsequent patch.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

Looks ok to me, but I'm not an ata expert.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
