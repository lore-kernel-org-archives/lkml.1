Return-Path: <linux-kernel-owner+w=401wt.eu-S1161329AbXCNPHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbXCNPHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161331AbXCNPHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:07:03 -0400
Received: from holomorphy.com ([66.93.40.71]:34610 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161329AbXCNPHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:07:01 -0400
Date: Wed, 14 Mar 2007 08:06:12 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/17] sparc: nr_free_pages() is unsigned long
Message-ID: <20070314150612.GU2986@holomorphy.com>
References: <E1HRPdC-0003S1-0h@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HRPdC-0003S1-0h@ZenIV.linux.org.uk>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 09:18:50AM +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/sparc/mm/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Dave, I trust you'll pick it up until I get a git tree going.

Acked-by: William Irwin <wli@holomorphy.com>


-- wli
