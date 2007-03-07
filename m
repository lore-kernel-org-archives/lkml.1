Return-Path: <linux-kernel-owner+w=401wt.eu-S2992765AbXCGX40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992765AbXCGX40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992770AbXCGX40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:56:26 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38882 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992765AbXCGX4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:56:25 -0500
Date: Wed, 7 Mar 2007 15:56:10 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Adam Litke <agl@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Bill Irwin <bill.irwin@oracle.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
Message-ID: <20070307235610.GS18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Adam Litke <agl@us.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070301234608.29532.66932.stgit@localhost.localdomain> <20070302002818.GF10643@holomorphy.com> <m1hcswbqru.fsf@ebiederm.dsl.xmission.com> <1173310008.26558.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173310008.26558.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 05:26:48PM -0600, Adam Litke wrote:
> :) Enter my remove-is_file_hugepages() patches (which I posted a few
> weeks ago).  I'll rework them and repost soon.  That should help to make
> all of this cleaner.

Those were great. I've wanted something like them for a long, long time.


-- wli
