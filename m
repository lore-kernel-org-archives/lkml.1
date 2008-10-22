Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYJVUNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYJVUNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYJVUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:13:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42378 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYJVUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:12:59 -0400
To: cl@linux-foundation.org
CC: miklos@szeredi.hu, penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <Pine.LNX.4.64.0810221252570.3562@quilx.com> (message from
	Christoph Lameter on Wed, 22 Oct 2008 12:54:30 -0700 (PDT))
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop>
 <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site>
 <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
 <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org>
 <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu> <48FC9CCC.3040006@linux-foundation.org>
 <E1Krz4o-0002Fi-Pu@pomaz-ex.szeredi.hu> <48FCCC72.5020202@linux-foundation.org>
 <E1KrzgK-0002QS-Os@pomaz-ex.szeredi.hu> <48FCD7CB.4060505@linux-foundation.org>
 <E1Ks0QX-0002aC-SQ@pomaz-ex.szeredi.hu> <48FCE1C4.20807@linux-foundation.org>
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu> <48FE6306.6020806@linux-foundation.org>
 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0810220822500.30851@quilx.com>
 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0810221252570.3562@quilx.com>
Message-Id: <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Oct 2008 22:11:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Christoph Lameter wrote:
> On Wed, 22 Oct 2008, Miklos Szeredi wrote:
> 
> > Why?  The kmem_cache_free() doesn't touch the contents of the object,
> > does it?
> 
> Because filesystem code may be running on other processors which may be 
> freeing the dentry.

You are not actually listening to what I'm saying.  Please read the
question carefully again.

Thanks,
Miklos
