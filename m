Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYESR5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYESR5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbYESR5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:57:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58366 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625AbYESR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:57:33 -0400
Message-ID: <4831BF0C.4010905@cs.helsinki.fi>
Date: Mon, 19 May 2008 20:55:24 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: MinChan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] Fix to return wrong pointer in slob
References: <48317CA8.1080700@gmail.com> <1211218837.18026.116.camel@calx>
In-Reply-To: <1211218837.18026.116.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> This looks good, but I would remove the 'else {' and '}' here. It's nice
> to have the 'normal path' minimally indented.
> 
> Otherwise,
> 
> Acked-by: Matt Mackall <mpm@selenic.com>
> 
> [cc:ed to Pekka, who manages the allocator tree]

Applied, thanks!
