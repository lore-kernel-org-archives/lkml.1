Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbXDFSqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbXDFSqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXDFSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:46:53 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:43735 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXDFSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:46:50 -0400
Date: Fri, 6 Apr 2007 21:46:47 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 2.6.20.4] pci-calgary: cleanup of unneeded macros
Message-ID: <20070406184647.GD31534@rhun.ibm.com>
References: <20070406085557.GB11218@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406085557.GB11218@bull.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 10:55:57AM +0200, Guillaume Thouvenin wrote:
> Cleanup unneeded macros used for register space address calculation. 
> Now we are using the EBDA to find the space address.
> 
> Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@bull.net>

Applied, thank you. I'll push it out with the next Calgary update.

Cheers,
Muli
