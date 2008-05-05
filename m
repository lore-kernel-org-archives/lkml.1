Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYEEFji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYEEFji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYEEFja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:39:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbYEEFj3 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:39:29 -0400
Date: Mon, 5 May 2008 15:39:14 +1000
From: David Chinner <dgc@sgi.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] xfs: use get_unaligned_* helpers
Message-ID: <20080505053914.GG155679365@sgi.com>
References: <1209755156.26173.72.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209755156.26173.72.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 12:05:56PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/xfs/xfs_inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Looks ok. Pulled into my tree for qa and later commit.

Cheers,

Dave
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
