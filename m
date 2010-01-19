Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824Ab0ASRkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0ASRkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297Ab0ASRkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:40:31 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47406 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0ASRka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:40:30 -0500
Date: Tue, 19 Jan 2010 18:40:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, Alberto Bertogli <albertito@blitiri.com.ar>,
       Jiri Kosina <jkosina@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/bio.c: fix shadows sparse warning.
Message-ID: <20100119174029.GT13771@kernel.dk>
References: <051f23a2b18d46fe0dd732a26e9d4507a19cfca4.1263863246.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051f23a2b18d46fe0dd732a26e9d4507a19cfca4.1263863246.git.tfransosi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18 2010, Thiago Farina wrote:
> fs/bio.c:81:33: warning: symbol 'bslab' shadows an earlier one
> fs/bio.c:74:25: originally declared here

Thanks, added.

-- 
Jens Axboe

