Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbZKBUNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbZKBUNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbZKBUNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:13:48 -0500
Received: from fieldses.org ([174.143.236.118]:44036 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbZKBUNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:13:47 -0500
Date: Mon, 2 Nov 2009 15:15:18 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: nfs/nfsd trees fetch failed
Message-ID: <20091102201518.GD19271@fieldses.org>
References: <20091102085835.651ddd02.sfr@canb.auug.org.au> <1257113019.3916.6.camel@heimdal.trondhjem.org> <20091102094151.3ad599a8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102094151.3ad599a8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 09:41:51AM +1100, Stephen Rothwell wrote:
> Hi Trond,
> 
> On Sun, 01 Nov 2009 17:03:38 -0500 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> >
> > Yes. It's a known problem: an upgrade+reboot that went awry combined
> > with a remote console failure. I'm hoping that Bruce might be able to
> > help out when he returns to the office tomorrow morning...
> 
> OK, thanks.

It should be working now.

--b.
