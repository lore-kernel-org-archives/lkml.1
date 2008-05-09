Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbYEITRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbYEITRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYEITRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:17:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17419 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbYEITRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:17:43 -0400
Date: Fri, 9 May 2008 21:17:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Zanussi <zanussi@comcast.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile returned 0? can't cope (bisected)
Message-ID: <20080509191734.GX16217@kernel.dk>
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com> <20080507211641.GR16217@kernel.dk> <1210231275.7301.17.camel@charm-linux> <1210306939.7205.9.camel@charm-linux> <20080509112651.GR16217@kernel.dk> <e9c3a7c20805091101w6402c17ak5dbee048a1845753@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20805091101w6402c17ak5dbee048a1845753@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09 2008, Dan Williams wrote:
> On Fri, May 9, 2008 at 4:26 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >  Dan, can I talk you into re-trying current git with this patch applied?
> >  It's basically the (now) reverted broken bits plus the fix from Tom from
> >  this email.
> >
> 
> distcc appears to be  happy.
> 
> Tested-by: Dan Williams <dan.j.williams@intel.com>

Super, Tom I already committed this patch as coming from you. If you
want a SOB added, let me know.

-- 
Jens Axboe

