Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXI1Gjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXI1Gjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbXI1GjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:39:25 -0400
Received: from mx10.go2.pl ([193.17.41.74]:40266 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754258AbXI1GjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:39:25 -0400
Date: Fri, 28 Sep 2007 08:41:47 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 0/2]  Fix unlocked call to idr_find()
Message-ID: <20070928064147.GC1767@ff.dom.local>
References: <20070927143354.663489000@bull.net> <20070928055256.GA1767@ff.dom.local> <46FC9B68.7010205@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FC9B68.7010205@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 08:12:56AM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
> >On Thu, Sep 27, 2007 at 04:33:54PM +0200, Nadia.Derbey@bull.net wrote:
> >
> >>This a series of 2 patches that should be applied on top of the other ipc
> >>patches, in 2.6.23-rc6-mm1.
> >
> >...
> >
> >>They should be applied to 2.6.23-rc6-mm1, in the following order:
> >
> >
> >Didn't you mean 2.6.23-rc8-mm1, btw?
> >
> >Regards,
> >Jarek P.
> >
> 
> No, what I wrote is exactly what I meant: unfortunately I couldn't get 
> the rc8-mm1 yet.
> But, Before building the patch, I applied the ipc patches that had been 
> integrated in rc7-mm1.
> Nothing happened in rc8-mm1.
> So you should have no problem appying these patches to your rc8-mm1 tree.

I didn't manage with rc6-mm1, maybe I've messed something.
With rc8-mm2 it's OK - a minor offset only.

Cheers,
Jarek P. 
