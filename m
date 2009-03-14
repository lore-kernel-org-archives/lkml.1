Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbZCNCK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbZCNCK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZCNCKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:10:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:22770 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZCNCKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=l+XPtLnOn86+xfXhD+Ut/WOVqmLtAe3XZGKvE2SXq4wPa+cVY7DKX+RspwSf0DVNYn
         xkPqh8GxG1yvjkYzYfIRlnKKV+psrvQZIIMGflTszOmxc6fV4nbmekIogihw2CNh+K+G
         x+GgYRBvv5y1jzYWAWhEjv4lCjQu+eCXCI3p0=
Message-ID: <49BB1213.6050908@gmail.com>
Date: Sat, 14 Mar 2009 11:10:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <1236920578-2179-12-git-send-email-tj@kernel.org> <200903132021.55921.bzolnier@gmail.com> <49BB0ECB.6090003@kernel.org>
In-Reply-To: <49BB0ECB.6090003@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
...
>> with at least linux-next/pata-2.6 tree so why not introduce block

Bart, can you please tell me git vector for the above tree?

Thanks.

-- 
tejun
