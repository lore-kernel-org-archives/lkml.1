Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYJXHzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYJXHzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYJXHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:55:35 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:38691 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJXHze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ne+lLgLkJRp5Hz9c5v1f0I49kjdjT6HspkXOzZ9+2DbjnuV9kewKKof/psxyGF3luI
         m5zK7LGIOomzwe6L8lBDW37XOq1qTasTeNeUeDiLDkKtMHRPkikl1PcKBQKYw8OhXxyI
         O+i22tbToTw9/mNbrkzCQTfwEvkIb6qIhF4i4=
Message-ID: <807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
Date: Fri, 24 Oct 2008 13:25:33 +0530
From: "Nikanth K" <nikanth@gmail.com>
To: "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 13/13] dm-mpath: convert to request-based
Cc: jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, "Nikanth Karthikesan" <knikanth@suse.de>
In-Reply-To: <20080912.104727.38325381.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104727.38325381.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 8:17 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch converts dm-multipath target to request-based from bio-based.
>

Can we keep both the bio-based as well as request-based dm-multipath?

Thanks
Nikanth Karthikesan
