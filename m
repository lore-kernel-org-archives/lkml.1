Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYFHPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYFHPdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYFHPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:33:22 -0400
Received: from 1wt.eu ([62.212.114.60]:1606 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYFHPdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:33:21 -0400
Date: Sun, 8 Jun 2008 16:53:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Missing patch from stable [3/7]
Message-ID: <20080608145333.GE9389@1wt.eu>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk> <20080608122920.GA10491@1wt.eu> <1212936622.4020.236.camel@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212936622.4020.236.camel@tucsk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 04:50:22PM +0200, Miklos Szeredi wrote:
> On Sun, 2008-06-08 at 14:29 +0200, Willy Tarreau wrote:
> 
> > Well, you know the implications of leaving these known bugs open more than
> > me. If you think some of them are really not needed, I'm fine with this,
> > but some definitely fix real bugs (judging by the code and the comments).
> 
> Yeah.  Perhaps there should also be a rule, that -stable patches for
> EXPERIMENTAL stuff (like ecryptfs) are automatically rejected.  And then
> they wouldn't increase the workload for the people collecting/reviewing
> the stable series.

That would indeed help. However, half of the kernel is tagged EXPERIMENTAL.
I don't even know if there is one distro which ships a working kernel with
experimental turned off :-/

Willy

