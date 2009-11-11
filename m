Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbZKKQIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbZKKQIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZKKQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:08:06 -0500
Received: from [95.166.99.235] ([95.166.99.235]:56185 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZKKQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:08:05 -0500
Date: Wed, 11 Nov 2009 17:08:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: jiffies fixes
Message-ID: <20091111160810.GQ8742@kernel.dk>
References: <4AFA03D2.6070701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA03D2.6070701@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use HZ-independent calculation of milliseconds.
> Add jiffies.h where it was missing since functions or macros
> from it are used.

Looks good, applied for 2.6.33.

> Oh, where has as-iosched.c in linux-next?

It's gone, it'll be dropped in the next release.

-- 
Jens Axboe

