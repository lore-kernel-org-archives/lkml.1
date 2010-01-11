Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451Ab0AKNUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0AKNUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309Ab0AKNUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:20:25 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39169 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0AKNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:20:24 -0500
Date: Tue, 12 Jan 2010 00:20:22 +1100
From: Simon Horman <horms@verge.net.au>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BUG?]Section mismatch dmar_ir_support()
Message-ID: <20100111132022.GC5198@verge.net.au>
References: <201001082127.22685.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001082127.22685.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ PCI list and maintainer CC added ]

On Fri, Jan 08, 2010 at 09:27:22PM +0200, Marin Mitov wrote:
> Hi all,
> 
> Please, look at how many times the same patch is proposed, 
> but still not fixed:-)
> 
> http://lkml.org/lkml/2009/10/3/3
> http://lkml.org/lkml/2009/11/13/271
> http://lkml.org/lkml/2009/12/4/462
> http://lkml.org/lkml/2009/12/16/424
> http://lkml.org/lkml/2009/12/20/21
> 
> Sure I could be missing some other postings :-)
> 
> Who could take care of it? And should we?

I've been wondering about that too.
The patch seems correct to me.

