Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYE1NiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYE1NiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYE1Nh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:37:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52718 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYE1Nhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:37:55 -0400
Subject: Re: [PATCH 1/3] Move hugetlb_acct_memory()
From: Adam Litke <agl@us.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, dean@arctic.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, dwg@au1.ibm.com, linux-mm@kvack.org,
       andi@firstfloor.org, kenchen@google.com, apw@shadowen.org, abh@cray.com
In-Reply-To: <20080527185048.16194.40237.sendpatchset@skynet.skynet.ie>
References: <20080527185028.16194.57978.sendpatchset@skynet.skynet.ie>
	 <20080527185048.16194.40237.sendpatchset@skynet.skynet.ie>
Content-Type: text/plain
Organization: IBM
Date: Wed, 28 May 2008 08:37:45 -0500
Message-Id: <1211981865.12036.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 19:50 +0100, Mel Gorman wrote:
> A later patch in this set needs to call hugetlb_acct_memory() before it
> is defined. This patch moves the function without modification. This makes
> later diffs easier to read.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Adam Litke <agl@us.ibm.com>

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

