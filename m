Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZC3RWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZC3RWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZC3RWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:22:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:51567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZC3RWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:22:02 -0400
Message-ID: <49D0FFB1.5080202@kernel.org>
Date: Tue, 31 Mar 2009 02:21:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: petkovbb@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and  misc
 cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <200903301650.11429.bzolnier@gmail.com>
In-Reply-To: <200903301650.11429.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 17:21:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.

Bartlomiej Zolnierkiewicz wrote:
> Not yet, we discussed this two weeks ago and the only thing that changed
> in the meantime is that we are in the merge window now and I'm ultra busy
> instead of being just really busy.  Do not worry though -- your last two
> patchsets are a very good motivator for quilt->git conversion (much better
> than i.e. some unproductive preaching).

Sounds greate.  Just lemme know when your tree is ready.  I'll prep
cleanly merged git tree you and Jens can pull from.

Thanks.

-- 
tejun
