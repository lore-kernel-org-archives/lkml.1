Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYE1UjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYE1UjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYE1UjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:39:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36797 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYE1UjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:39:05 -0400
Subject: Re: [PATCH 2/3] hugetlb-move-reservation-region-support-earlier
From: Adam Litke <agl@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, kenchen@google.com,
       dwg@au1.ibm.com, andi@firstfloor.org, Mel Gorman <mel@csn.ul.ie>,
       dean@arctic.org, abh@cray.com
In-Reply-To: <1211929796.0@pinky>
References: <exportbomb.1211929624@pinky>  <1211929796.0@pinky>
Content-Type: text/plain
Organization: IBM
Date: Wed, 28 May 2008 15:38:44 -0500
Message-Id: <1212007124.12036.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 00:09 +0100, Andy Whitcroft wrote:
> The following patch will require use of the reservation regions support.
> Move this earlier in the file.  No changes have been made to this code.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Acked-by: Adam Litke <agl@us.ibm.com>

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

