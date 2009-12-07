Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZLGSfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZLGSfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbZLGSfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:35:36 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58383 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbZLGSff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:35:35 -0500
Date: Mon, 7 Dec 2009 19:35:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Do not access cfqq after freeing it
Message-ID: <20091207183541.GC8742@kernel.dk>
References: <20091207181547.GG16900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207181547.GG16900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Vivek Goyal wrote:
> Fix a crash during boot reported by Jeff Moyer. Fix the issue of accessing
> cfqq after freeing it.

Thanks Vivek, applied.

-- 
Jens Axboe

