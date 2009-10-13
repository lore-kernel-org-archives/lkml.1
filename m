Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbZJMHS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbZJMHS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933616AbZJMHSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:18:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38657 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbZJMHSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:18:23 -0400
Date: Tue, 13 Oct 2009 09:17:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mikem@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: Add cciss_allow_hpsa module parameter.
Message-ID: <20091013071746.GO9228@kernel.dk>
References: <20091012153606.4367.73416.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012153606.4367.73416.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12 2009, Stephen M. Cameron wrote:
> Add cciss_allow_hpsa module parameter.  This parameter causes
> the cciss driver to ignore any Smart Array devices known to be
> supported by the hpsa driver.

Thanks, applied.

-- 
Jens Axboe

