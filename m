Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZFSOjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZFSOjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZFSOi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:38:59 -0400
Received: from [212.98.175.89] ([212.98.175.89]:34121 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbZFSOi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:38:59 -0400
Date: Fri, 19 Jun 2009 17:40:27 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: blk-settings.c integer truncation
Message-ID: <20090619144027.GA3244@localdomain.by>
References: <20090619090405.GA3222@localdomain.by> <yq1ljnoe1yq.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ljnoe1yq.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/19/09 10:24), Martin K. Petersen wrote:
> >>>>> "Sergey" == Sergey Senozhatsky <sergey.senozhatsky@mail.by> writes:
> 
> Sergey> Hello.  commit e475bba2fdee9c3dbfe25f026f8fb8de69508ad2
> Sergey> introduced 'void blk_set_default_limits(struct queue_limits
> Sergey> *lim)'
> 
> This was discussed here a couple of days ago.  There is a fix in Jens'
> tree but Linus hasn't pulled it yet.
> 
> In any case the warning is harmless.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 


OK. Thanks.

	Sergey
