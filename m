Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZFZQF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZFZQF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZFZQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:05:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49607 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZFZQFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:05:22 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] cfq-iosched: get rid of __GFP_NOFAIL
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 26 Jun 2009 12:05:16 -0400
In-Reply-To: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> (Jens
	Axboe's message of "Fri, 26 Jun 2009 11:05:18 +0200")
Message-ID: <x49fxdn9e0z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> Hi,
>
> So these are the two patches that get rid of __GFP_NOFAIL in
> the CFQ IO scheduler. It's been tested with injecting errors
> into the cfqq allocation and verifying that it both triggers
> and works as expected.

You forgot to mention why you are doing this.

Cheers,
Jeff
