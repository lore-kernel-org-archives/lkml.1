Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZFEPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZFEPE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZFEPET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:04:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZFEPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:04:18 -0400
Message-ID: <4A2933E4.4040502@redhat.com>
Date: Fri, 05 Jun 2009 11:04:04 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH][mmtom] remove file arguement of swap_readpage
References: <1244212423-18629-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1244212423-18629-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> The file argument resulted from address_space's readpage
> long time ago.
> 
> Now we don't use it any more. Let's remove unnecessary
> argement.
> 
> This patch cleans up swap_readpage.
> It doesn't affect behavior of function.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Rik van Riel <riel@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
