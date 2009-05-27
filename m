Return-Path: <linux-kernel-owner+w=401wt.eu-S1763679AbZE0NR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763679AbZE0NR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZE0NRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:17:17 -0400
Received: from mailhost-r0-m2.netultra.net ([78.40.49.194]:57756 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761560AbZE0NRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:17:16 -0400
Date: Wed, 27 May 2009 15:15:55 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090527131555.GA3277@localhost.localdomain>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
 <20090526152501.GA20968@localhost.localdomain>
 <20090526164117.GJ11363@kernel.dk>
 <20090526170845.GA3226@localhost.localdomain>
 <20090526204703.GM11363@kernel.dk>
 <20090526211119.GO11363@kernel.dk>
 <20090527052101.GA28517@localhost.localdomain>
 <20090527054921.GA4127@localhost.localdomain>
 <20090527092052.GV11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527092052.GV11363@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-05-25)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, that patch was still buggy. I have it fixed now locally, I'll post
> a v8 within the hour!

The two systems having problems with v7 now run v8 and everything seems
smooth for now. Thanks for the bugfixes.

-- 
Damien Wyart
