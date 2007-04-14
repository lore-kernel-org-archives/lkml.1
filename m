Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXDNKOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXDNKOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXDNKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:14:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXDNKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=bRw6Lx4UN3DWL6XkzYSquoCFZHNNQ7mWRE077oQB66OSLyyIZUCn3/kuDHDVjUEGDMsR2eb7O9tBe81hprA5r/kIsCAsnkVRboSm+bkcTFeqmdbU1h/0XM6qVMs/zE6VI1t+o/faE1F5fuddLQcxzxcQHv12X/3EY1J/tfgRgSI=
Date: Sat, 14 Apr 2007 15:46:07 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: kernel-janitors@lists.osdl.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [KJ][PATCH 03/04]use set_current_state in fs
Message-ID: <20070414101607.GA16817@arun.site>
References: <20070414084956.GD14084@arun.site> <4620A13F.6060502@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4620A13F.6060502@cosmosbay.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:39 Sat 14 Apr     , Eric Dumazet wrote:
> Milind Arun Choudhary a écrit :
> >use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/nfs
> Probably a dumb question, so please forgive me.
no.
you have a valid point

My bad :(
I should probably be enjoying my weekend outdoors..
breath some fresh air...
rather than sending such dumb patches..

ummmmmmmm
booting into  windows might help :)

> Why are you  forcing a memory barrier here, (and also on your other 
> patches).
> Is'nt a  __set_current_state(TASK_RUNNING); appropriate ?
it is..

would resend later

Njo!!!
-- 
Milind Arun Choudhary
