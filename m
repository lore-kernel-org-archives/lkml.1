Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXELLlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXELLlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbXELLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:41:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21717 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbXELLlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aNeiZy4ELjW8sGcYOjjQrzPgniHHF9Ust5g9Yd+r200ufAAKwWAusrwAjNqIPsGK9KN4om02T9pUx4m1whHpLAWvcYm6+Yls02fsZp165r1yo+DpEI68cWY+YcEXPIyH1tBsXbzU8jV0/jWqq1C19V+W1zxQy1r42VGuFALGxDc=
Date: Sat, 12 May 2007 15:40:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070512114038.GE8337@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070512100949.GC8337@cvg> <84144f020705120315i47b033e9w702266ab4d0631bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705120315i47b033e9w702266ab4d0631bc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Sat, May 12, 2007 at 01:15:14PM +0300]
| Hi Cyrill
| 
| On 5/12/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| >you know I've got a question (may be it's stupid) - what a
| >sense to discard UDF_I_* macroses? I mean as I see they
| >don't slow down execution of the code...
| 
| They make the code harder to read and maintain.
| 

Hi Pekka,

thanks for eplanation. Btw, maybe I also should
convert the UDF coding style to Linux kernel coding
style?

		Cyrill

P.S.
It's strange that I haven't got any comments from
Ben Fennema :(

