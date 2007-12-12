Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXLLW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXLLW6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXLLW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:58:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:40236 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXLLW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uPuAjpJrX6G5euSyzXjuNGF64t3fs0wr+G/692GSmfIKP4V8UD4dWDCZGTDT9TfObscDqW5pha76A4oIfvbnSmv1Q53OxXx9FXLig6olsqJDkcIxUNxlYuK7gBoIwfQXul0DwO8Pg/UHt3ddsy5U37SLNm74DsZ66XIyHJLKc2w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 19/30] blk_end_request: changing ide-scsi (take 4)
Date: Wed, 12 Dec 2007 22:48:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
References: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712122248.15838.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007, Kiyoshi Ueda wrote:
> This patch converts ide-scsi to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

looks good, ACK

ditto for patches #23 and #25
