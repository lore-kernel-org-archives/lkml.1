Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbYBSA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbYBSA3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYBSA3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:29:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:24040 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYBSA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:29:12 -0500
Date: Mon, 18 Feb 2008 16:28:00 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [GIT PATCH 0/2] ocfs2: Fix endian bug in o2dlm
	negotiation
Message-ID: <20080219002800.GE22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 06:07:31PM -0800, Joel Becker wrote:
> 
> These patches fix up two outstanding issues from commit
> d24fbcda0c4988322949df3d759f1cfb32b32953 (ocfs2: Negotiate locking
> protocol versions).  The first patch cleans up the comparison functions
> based on Andrew's review.  The second fixes a byte-order bug in
> heterogeneous clusters.
> 
> I've tested the changes in said hetergeneous envirnoment.  Comments
> and review welcome.  Mark, you can pull these into ocfs2.git if they
> meet your approval.

Both these look good to me, thanks Joel.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
