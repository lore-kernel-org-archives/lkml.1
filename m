Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbXGRVJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbXGRVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759638AbXGRVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:07:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbXGRVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qd/bzKlSuGVUjHdAhGCimInkW+HxKEscNFz4AttbzA+pWGyNzYCEBGDNxnrh1wOOiiKpbQSZIWVGfc2hUjuPEq7N6jr1YEfWR79ocfzZQC3BOmemcaWqQmVwlmR3ecyzH3Kj9FKCvNN3FMGE3xGLmVei8VXXgtQAw80gJoRC78Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 24/33] ide-scsi: sg chaining support
Date: Wed, 18 Jul 2007 23:03:50 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681555-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11845792681555-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707182303.50396.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007, Jens Axboe wrote:
> Cc: bzolnier@gmail.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
