Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbYBNOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbYBNOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYBNOGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:06:42 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34775 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbYBNOGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:06:41 -0500
Date: Thu, 14 Feb 2008 15:06:28 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0802141503170.7699@twin.jikos.cz>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Stephen Rothwell wrote:

> The tree consists of subsystem git and quilt trees.  Currently, the 
> quilt trees are integrated by importing them into appropriately based 
> git branches and then merging those branches.  

Now, would it be possible to have somewhere listed the URLs of git/quilt 
trees that were merged? The commit messages about merges with different 
branches aren't too informative, it might sometime be useful to know more 
about the trees that were merged.

Maybe just an additional file somewhere in the root of the source tree 
would be sufficient ...

Thanks,

-- 
Jiri Kosina
