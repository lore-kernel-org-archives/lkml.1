Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYKXUOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYKXUOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYKXUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:14:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38225 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbYKXUOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:14:05 -0500
Date: Mon, 24 Nov 2008 12:14:02 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix sparse warnings
Message-ID: <20081124201402.GA8284@us.ibm.com>
References: <154e089b0811241205m293b5824of0fa753c1f8c33a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811241205m293b5824of0fa753c1f8c33a6@mail.gmail.com>
X-Operating-System: Linux 2.6.27-7-generic (i686)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.11.2008 [21:05:31 +0100], Hannes Eder wrote:
> Impact: fix sparse warnings
> 
> Fix the following sparse warnings:
> 
>   mm/hugetlb.c:375:3: warning: returning void-valued expression
>   mm/hugetlb.c:408:3: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks,
Nish
