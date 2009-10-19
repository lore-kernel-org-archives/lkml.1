Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZJSIGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZJSIGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZJSIGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:06:16 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45693 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755794AbZJSIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:06:15 -0400
Date: Mon, 19 Oct 2009 03:40:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] page allocator: Always wake kswapd when restarting
 an allocation attempt after direct reclaim failed
In-Reply-To: <1255689446-3858-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910190340310.24325@gentwo.org>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <1255689446-3858-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

