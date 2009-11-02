Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZKBKq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZKBKq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZKBKq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:46:59 -0500
Received: from [95.166.99.235] ([95.166.99.235]:41525 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbZKBKq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:46:56 -0500
Date: Mon, 2 Nov 2009 11:38:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] bio_put(): add bio_clone() to the list of functions in
	the comment
Message-ID: <20091102103804.GK10727@kernel.dk>
References: <1257023932-22868-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257023932-22868-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 31 2009, Alberto Bertogli wrote:
> In bio_put()'s comment, add bio_clone() to the list of functions that can
> give you a bio reference.

Thanks, applied to for-linus.

-- 
Jens Axboe

