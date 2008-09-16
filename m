Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYIPCBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYIPCBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 22:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYIPCBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 22:01:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42681 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYIPCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 22:01:20 -0400
Date: Tue, 16 Sep 2008 12:01:18 +1000
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080916020100.GA23389@verge.net.au>
References: <20080915.120917.36004302.davem@davemloft.net> <20080915201749.GB3994@havoc.gtf.org> <20080915.132716.267218808.davem@davemloft.net> <20080915.141159.181213705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915.141159.181213705.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 02:11:59PM -0700, David Miller wrote:

[snip]
> 
> Not a 2.6.27 regression, this problem has been there forever.
> 
> 	Magnus Damm (2):
> 	      smc91x: fix nowait printout
> 
> This one is good but the commit message needs to be fixed up.
> It references a raw SHA1 ID but does not give the commit message
> header line as well, which is a requirement.
> 
>       smc91x: SMC_IO_SHIFT platform data support for default case
> 
> Ok, but needs commit header line text for referenced commit.

[snip]

Hi Dave,

can you confirm that the commit message requirement stands even
if the SHA1 ID references Linus' tree? I personally think that is
reasonable, I just want to confirm that is the requirement.

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

