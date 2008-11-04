Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYKDR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYKDR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYKDR6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:58:23 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:17552 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYKDR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=SR7GNEtz/ARYg+s5TCNUXwIQy58no6F7v2cft6LJLs3DxIqWOaow1FWM4mo6IoK36U
         66n3JRiWvxApeLzVyUX7xwv5nQPR5TCs87NC/kH3rGPAvw3BN30fErQ5hbHF5ysF/6uQ
         lvqob9+mgy4BOWHHF+FEWZ6OlBmjvh+9ePme4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 __log_wait_for_space: no transactions
Date: Tue, 4 Nov 2008 18:48:03 +0100
User-Agent: KMail/1.9.10
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <200811012121.29534.bzolnier@gmail.com> <20081104145016.GJ30291@mit.edu>
In-Reply-To: <20081104145016.GJ30291@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811041848.03570.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, Theodore Tso wrote:
> Any updates on whether the patch that I've posted has solved this regression?

I've been running it since Saturday and the problem hasn't re-occured yet.

I think that we can assume that the bug is fixed. :)

Thanks,
Bart
