Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZIZOPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZIZOPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIZOPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:15:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56440 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZIZOPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:15:18 -0400
Date: Sat, 26 Sep 2009 16:15:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/bio.c: move EXPORT* macros to line after function
Message-ID: <20090926141521.GZ23126@kernel.dk>
References: <BD79186B4FD85F4B8E60E381CAEE190901D4276C@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901D4276C@mi8nycmail19.Mi8.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25 2009, H Hartley Sweeten wrote:
> As mentioned in Documentation/CodingStyle, move EXPORT* macro's
> to the line immediately after the closing function brace line.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Thanks, applied.

-- 
Jens Axboe

