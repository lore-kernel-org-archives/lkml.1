Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYAGFCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYAGFCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYAGFC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:02:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:33002 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYAGFCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mxAO57rlYzQFyBeIMyElkheZ+PQr6mJiHQwYwcw8fH5wq36PrNpzwUCniHzOskaMvIKDIlNRWftUshVPU5POx08c/+ZcQ2RJTrNai9tZnIoodYxzioMgU3U9MP4Zc3xXI5uKg7ni/ZBEo+lehbX3W9zuIXgmVSRBY7+PQZg5Sfs=
Message-ID: <4781B259.6040907@gmail.com>
Date: Mon, 07 Jan 2008 14:02:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Don't blatt first element of prv in sg_chain()
References: <200801071538.43371.rusty@rustcorp.com.au>
In-Reply-To: <200801071538.43371.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> I realize that sg chaining is a ploy to make the rest of the kernel
> devs feel the pain of the SCSI subsystem.  But this was a little
> unsubtle.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Embarrassingly Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
