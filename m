Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZFSOYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZFSOYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZFSOY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:24:28 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:45200 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZFSOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:24:27 -0400
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: blk-settings.c integer truncation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090619090405.GA3222@localdomain.by>
Date: Fri, 19 Jun 2009 10:24:13 -0400
In-Reply-To: <20090619090405.GA3222@localdomain.by> (Sergey Senozhatsky's
	message of "Fri, 19 Jun 2009 12:04:05 +0300")
Message-ID: <yq1ljnoe1yq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A3B9F90.010B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sergey" == Sergey Senozhatsky <sergey.senozhatsky@mail.by> writes:

Sergey> Hello.  commit e475bba2fdee9c3dbfe25f026f8fb8de69508ad2
Sergey> introduced 'void blk_set_default_limits(struct queue_limits
Sergey> *lim)'

This was discussed here a couple of days ago.  There is a fix in Jens'
tree but Linus hasn't pulled it yet.

In any case the warning is harmless.

-- 
Martin K. Petersen	Oracle Linux Engineering
