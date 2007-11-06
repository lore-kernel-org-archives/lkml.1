Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXKFFIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXKFFIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXKFFHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:07:55 -0500
Received: from qb-out-0506.google.com ([72.14.204.228]:54474 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbXKFFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ye0PWPxcDWnfhprUNeK3wzxftQoPiyKRaozf/q5krDFj/f2PZo6TCyA8lzdkG4FbW10i6h2UKg5hFtNNkknGvgoZ9Nu9AWYSqUTFw7OVCGbfzYJSwdZWn+cRxAc3UisetWIRLkAQSnovZasAqXxedxapJmeyG2cpE2s+S4gDr24=
Date: Tue, 6 Nov 2007 13:06:44 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Dong Pu <cocobear.cn@gmail.com>
Subject: Re: [git Patch] mm/util.c: Remove needless code
Message-ID: <20071106050644.GB2478@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071106031207.GA2478@hacking> <20071105203816.3f8b2e7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105203816.3f8b2e7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Thanks.  This was already fixed by
>
>http://www.mail-archive.com/mm-commits@vger.kernel.org/msg28294.html
>
>(which is somewhere in one of my ever-growing number of for-2.6.24 queues)

Thanks, Andrew.

