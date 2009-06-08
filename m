Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZFHO0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZFHO0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZFHO0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:26:02 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54635 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755872AbZFHO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:26:01 -0400
Date: Mon, 8 Jun 2009 10:25:27 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Properly account for the number of page cache pages
 zone_reclaim() can reclaim
In-Reply-To: <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906081024070.21954@gentwo.org>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that I am not aware of any current user for the advanced zone reclaim
modes that include writeback and swap.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

