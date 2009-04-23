Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZDWXNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZDWXNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbZDWXNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:13:37 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:37087 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbZDWXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:36 -0400
Date: Thu, 23 Apr 2009 19:04:20 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com, peterz@infradead.org,
       penberg@cs.helsinki.fi
Subject: Re: [PATCH 19/22] Update NR_FREE_PAGES only as necessary
In-Reply-To: <20090423160610.a093ddf0.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0904231903230.26300@qirst.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-20-git-send-email-mel@csn.ul.ie> <20090423160610.a093ddf0.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Andrew Morton wrote:

> If not, what _is_ it asserting?

That the alignment of an order N page in the max order block is proper?


