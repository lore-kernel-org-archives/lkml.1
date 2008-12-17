Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757561AbYLQEuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYLQEuc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 23:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYLQEuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 23:50:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47941 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYLQEuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 23:50:16 -0500
Date: Wed, 17 Dec 2008 04:50:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, haradats@nttdata.co.jp
Subject: Re: [PATCH] introduce new LSM hooks where vfsmount is available.
Message-ID: <20081217045010.GW28946@ZenIV.linux.org.uk>
References: <49487EEF.1070207@nttdata.co.jp> <20081217044215.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217044215.GV28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 04:42:16AM +0000, Al Viro wrote:
> On Wed, Dec 17, 2008 at 01:24:15PM +0900, Kentaro Takeda wrote:
> > Al, would you respond to this patch?
> > James, Andrew and we are waiting for your Acked-by: response.
> 
> In queue.  FWIW, I'm about to post the current audit patchset to linux-audit,
> push that crap to audit git and then I'm through with that turd.  And
> _finally_ can get to VFS queue sorting.

"That crap" == audit patches for .29-rc1, that is.
