Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbXEPQBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbXEPQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXEPQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:01:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXEPQBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:01:42 -0400
Message-ID: <464B2AC2.10206@redhat.com>
Date: Wed, 16 May 2007 12:01:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
References: <20070516144205.GV26766@think.oraclecorp.com>
In-Reply-To: <20070516144205.GV26766@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> For example, I'll pick on xfs for a minute.  compilebench shows the
> default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
> kernel trees.  Dave Chinner gave me some mount options that make it
> dramatically better, but it still writes at 10MB/s on a sata drive that
> can do 80MB/s.  Ext3 is better, but still only 20MB/s. 
> 

Now try JFS. My lawn grows faster than it can write a new kernel tree.

What we need is a tool that shows *why* this stuff happens...

