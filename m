Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYKLWfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYKLWfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYKLWfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:35:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYKLWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:35:23 -0500
Date: Wed, 12 Nov 2008 16:34:48 -0600
From: David Teigland <teigland@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dlm: trivial annotation of be16 value
Message-ID: <20081112223448.GE29551@redhat.com>
References: <1226086898.11596.49.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226086898.11596.49.camel@brick>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:41:38AM -0800, Harvey Harrison wrote:
> fs/dlm/dir.c:419:14: warning: incorrect type in assignment (different base types)
> fs/dlm/dir.c:419:14:    expected unsigned short [unsigned] [addressable] [assigned] [usertype] be_namelen
> fs/dlm/dir.c:419:14:    got restricted __be16 [usertype] <noident>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/dlm/dir.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

Thanks, adding this to next branch.
Dave

