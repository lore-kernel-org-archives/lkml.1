Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYLaCF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYLaCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYLaCFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:05:09 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:8016 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021AbYLaCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:05:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQDACthWkl5LB1fgWdsb2JhbACTdgEBFiK4VYZE
X-IronPort-AV: E=Sophos;i="4.36,305,1228051800"; 
   d="scan'208";a="284655072"
Date: Wed, 31 Dec 2008 13:05:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: access(2) regressions in current mainline
Message-ID: <20081231020503.GD10725@disturbed>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20081230172901.GA5610@lst.de> <20081230170941.GA5083@lst.de> <20081230134248.GA30124@lst.de> <24505.1230656810@redhat.com> <32709.1230657626@redhat.com> <605.1230659651@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <605.1230659651@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:54:11PM +0000, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Try to grab git://oss.sgi.com/xfs-cmds, it's in the xfstests subdir.
> 
> Hmmm...  It requires an 'fsstress', but which of the several things that go by
> that name is it referring to?

You need to build xfstests, and then it will build the xfstests/ltp
directory and that is where it will find the fsstress binary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
