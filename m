Return-Path: <linux-kernel-owner+w=401wt.eu-S940715AbXGSRws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940715AbXGSRws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762531AbXGSRwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:52:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33822 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbXGSRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:52:37 -0400
Date: Thu, 19 Jul 2007 10:52:07 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Bill Irwin <bill.irwin@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] hugetlbfs read() support
Message-ID: <20070719175207.GH26380@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Nishanth Aravamudan <nacc@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com> <20070718221950.35bbdb76.akpm@linux-foundation.org> <1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com> <20070719095850.6e09b0e8.akpm@linux-foundation.org> <20070719170759.GE2083@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719170759.GE2083@us.ibm.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 10:07:59AM -0700, Nishanth Aravamudan wrote:
> But I do think a second reason to do this is to make hugetlbfs behave
> like a normal fs -- that is read(), write(), etc. work on files in the
> mountpoint. But that is simply my opinion.

Mine as well.


-- wli
