Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXFUQdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXFUQdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbXFUQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:33:34 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50404 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbXFUQdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:33:33 -0400
Date: Thu, 21 Jun 2007 12:33:30 -0400
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, meelap@umich.edu
Subject: Re: [PATCH 008 of 8] knfsd: nfsd4: don't delegate files that have had conflicts
Message-ID: <20070621163330.GE4094@fieldses.org>
References: <20070621142604.727.patches@notabene> <1070621043119.1159@suse.de> <20070621162801.GD4094@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621162801.GD4094@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 12:28:01PM -0400, bfields wrote:
> The authorship information got lost on these last two patches--both were
> originally by Meelap Shah <meelap@umich.edu>.
> 
> (The problem may have been that I had a From: line for him but not a
> Signed-off-by: line?)

Hm, no, actually I think the same happened to patch 1 (from Marc Eshel)
and 4 (from Benny Halevy), neither which had missing signed-off-by's, so
probably your scripts have always ignored From: lines in the body of an
email, and I only just now noticed?

--b.
