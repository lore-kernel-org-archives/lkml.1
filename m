Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbXKTCSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbXKTCSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762435AbXKTCOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:14:20 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:16860 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762651AbXKTCOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:14:18 -0500
Date: Mon, 19 Nov 2007 18:13:21 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Kurt Hackel <kurt.hackel@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 47/59] fs/ocfs2: Add missing "space"
Message-ID: <20071120021321.GY28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <82a29b02f6151dd2d9a34d071e24f0726b8466d0.1195454436.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82a29b02f6151dd2d9a34d071e24f0726b8466d0.1195454436.git.joe@perches.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:53:34PM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |    4 ++--
>  fs/ocfs2/inode.c         |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Thanks, I'll put this in ocfs2.git.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
