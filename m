Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXLDN7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXLDN7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXLDNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:55:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:48679 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbXLDNzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=S3jUMc9TDqcni6a8VoMPChTPcsi2csPoqPvGWFpBRilqdxk9o9luM58/n9e7Nhy2F6PZ1NNStFs+OMs3r5KKNP4GEUtflQBdF92GzLyYnxK3ggc+2z3KhktU88WnAHdk8PIruZzX4/KANAtn65N6X8vBAaMo87JSeaATCyHe1aA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 20/28] blk_end_request: changing ide-scsi (take 3)
Date: Tue, 4 Dec 2007 14:47:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
References: <20071130.183243.66055473.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071130.183243.66055473.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712041447.04039.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> This patch converts ide-scsi to use blk_end_request().
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
