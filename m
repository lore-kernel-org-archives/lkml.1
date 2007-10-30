Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXJ3LoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXJ3LoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXJ3LoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:44:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:59008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbXJ3LoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QGtPz+yKDgmlvn7WtABL/uy3ZY6ImcC4fSZhHHOzA5tHp56q6lgGwDY2atgnJAI5S99wmLvi0s7TdwUoJMTik2moLHMt3L/q0bpdyuj9c+aJAcxfOBvEeh4PUmrNBdAnh/PhfmN1UFIHf++1o75n9Ny/JKTRSLROwkhrWxnDbsg=
Date: Tue, 30 Oct 2007 14:44:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clean up scatterlist.h and introduce macros for
	readability.
Message-ID: <20071030114401.GA7252@cvg>
References: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain> <20071029185803.GA7499@kernel.dk> <aa79d98a0710291320r5412ebcboc90234cc2ac56102@mail.gmail.com> <20071029202352.GF7499@kernel.dk> <20071029133707.a53aa406.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029133707.a53aa406.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Randy Dunlap - Mon, Oct 29, 2007 at 01:37:07PM -0700]
| On Mon, 29 Oct 2007 21:23:52 +0100 Jens Axboe wrote:
| 
| > On Mon, Oct 29 2007, Cyrill Gorcunov wrote:
| > > Could you please give a link to that explanation? It seems I've missed
| > > it somehow. Thanks.
| > 
| > (don't top post)
| > 
| > It was on linux-kernel, message id:
| > 
| > Message-ID: <20071023202017.GI14671@kernel.dk>
| 
| which can be seen at marc.info by using this URL:
| 
| http://marc.info/?i=20071023202017.GI14671@kernel.dk
| 
| ---
| ~Randy
| 

Thanks

		Cyrill

